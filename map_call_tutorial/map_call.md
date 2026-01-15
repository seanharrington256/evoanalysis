# Mapping and variant calling from short read data


<br>

[Home](https://github.com/seanharrington256/evoanalysis)

<br>



## Table of Contents

- [Quality control](#Quality-control)
	- [Initial quality check](#Initial-quality-check)
	- [Trimming](#Trimming)
	- [Post-trimmed QC](#Post-trimmed-QC)
- [Mapping](#Mapping)
	- [Mapping with BWA](#Mapping-with-BWA)
	- [Remove duplicates](#Remove-duplicates)
	- [Check mapping](#Check-mapping)
- [Variant calling](#Variant-calling)
- [Variant filtering](#Variant-filtering)




<br>
<br>
<br>



Today we'll go over the steps for mapping and variant calling short read (i.e., Illumina) data. We will cover assessing the quality of your reads, trimming reads, mapping reads to a reference genome, calling variants from the mapped reads, and filtering variants.


* Note that I'm making this tutorial last-minute, so it not going to be particularly comprehensive and might have errors in it



* **In the example scripts I have included, the file paths are all dummy paths that you will need to edit**

<br>
<br>



## Quality control


### Initial quality check


You should always check the quality of your raw data before you do anything with it, and do it soon after getting your raw data back. If there was some catastrophic problem at the sequencing facility and you got bad data back, you want to know that asap so you can request that they re-sequence. If entire samples failed, you probably want to exclude them from everything downstream.

The most common tool for assessing Illumina read quality is [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).

FastQC exists as a module on MedicineBow: `fastqc/0.12.1`



The command to run FastQC on a fastq file is very simple:

```
fastqc -o OUTPUT_DIRECTORY FILE.fastq.gz
```

Where you would just replace `OUTPUT_DIRECTORY` with the path to wherever you want output to go, and `FILE.fastq.gz` with the name of your fastq file. You can also feed it a list of fastq files, including by globbing. You can also use multiple threads, but note that there isn't a speedup for using more threads than the number of files you are inputting.


This will run fastqc with 2 threads (`-t` option) for all files ending `.fastq.gz` in the current directory:

```
fastqc -t 2 -o OUTPUT_DIRECTORY *.fastq.gz
```

You can see an example of how I have run this [here](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/fastqcarray.slurm).

* Note that this script was designed for a scenario in which each sample has a directory that contains 2 fastq files, rather than a single directory that contains all fastq files



**You can see an example fastqc report [here](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/R179196_S12_L004_R1_001_fastqc.html) - you will have to download the file and open it, Github won't render the html.**

Most of this looks pretty good, except we can see a good bit of polyG tail in some reads in the bottom plot.

These reports are great, but for population genetic and phylogenetic analyses, you'll be sequencing a bunch of samples and you don't want to have to look at each report individually.

[MultiQC](https://github.com/MultiQC/MultiQC) is a very nice tool that compiles multiple fastqc reports into a single aggregated report.

MultiQC also exists as a module on MedicineBow: `multiqc/1.24.1`

Running MultiQC is also very easy and fast. The best way to run it is to just navigate to a directory with all your FastQC reports you want to summarize and run:

```
multiqc .
```

* this is very fast and can be done interactively unless you have a truly huge number of FastQC reports to aggregate


That will create a report like the one [here](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/multiqc_report.html)


You will again have to download this html file to view it. You should see that most stats look pretty good, but some files have a good bit of adapter in them. Adapter is non-biological sequence and should be trimmed off before moving ahead.


<br>



### Trimming


Trimming refers to the process of removing parts of reads or entire reads from the dataset based on quality or presence of adapter. There are multiple tools that will trim reads. I like to use [fastp](https://github.com/OpenGene/fastp).


The basic command for fastp on paired-end data is:

`fastp -i in.R1.fq.gz -I in.R2.fq.gz -o out.R1.fq.gz -O out.R2.fq.gz`


where 
- `-i in.R1.fq.gz` designates the input forward read
- `-I in.R2.fq.gz` designates the input reverse read
- `-o out.R1.fq.gz` designates the output (trimmed forward read)
- `-O out.R2.fq.gz` designates the output (trimmed reverse read)


with default settings, fastp will search for adapter sequence in reads and remove it, as  discard any reads where more than 40% of bases have a quality score below 15, and remove poly-G tails.

I typically also add sliding window trimming to cut the end off of a read whenever the average base quality for a window of 4 bases drops below 20 and some other options.

**You can see an example script for fastp [here](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/fastp.slurm).** To figure out what all of the options are that I use, go look at the fastp documentation linked above. 90% of learning to code is learning to read and interpret documentation and figure out error reports.


In your output directory from fastp, you will end up with new fastq files that have been cleaned for quality. You should still never delete your raw, uncleaned fastq files. You will need to upload them when you publish, and there are many reasons why you might want to go back to them fresh. This does unfortunately mean that you have already roughly doubled the amount of storage your data takes up before even doing any analysis.



<br>



### Post-trimmed QC


Once you have trimmed your data, you should run FastQC and MultiQC on the resulting trimmed fastq files to make sure there are no lingering issues. If there are, you may need to trim again with different settings or dig deeper to figure out what is going on.


An example trimmed MultiQC report is [here](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/multiqc_reportTRIMMED.html). Quality metrics all look pretty good and there is almost no adapter left, so these data are ready to move forward.


<br>
<br>
<br>



## Mapping


### Mapping with BWA

Once the reads are clean, you can proceed to map the reads to your reference genome. The most commonly used program for genomic Illumina reads is [BWA](https://github.com/lh3/bwa), specifically BWA-MEM. Note that if you are aligning transcriptomic reads (i.e., RNA data), you will need to use a splice-aware aligner like [STAR](https://github.com/alexdobin/STAR).


BWA returns sam files that detail the sequence of each read and where they map to in the genome. You should immediately convert these to bam files that take up much less disk space and then delete the sam files. I personally pipe the output from BWA directly to samtools for conversion to bam files and never create sam files on disk at all. 

Before mapping to a reference genome with BWA, you will have to index the reference genome fasta file:

```
bwa index ref.fasta
```

After that, you are ready to map.


**You can see an example bwa mapping script [here](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/bwa.slurm).**

<br>

### Remove duplicates

Most Illumina library preps involve a PCR step. However, when sequencing the goal is to sequence at a concentration such that you only sequence reads from different starting DNA molecules - i.e., you want your reads to start from different cells or different chromosome copies, you do not want to sequence multiple PCR copies of the same starting molecule. When you end up with multiple copies of the same starting molecule, these are referred as PCR duplicates, and you want to remove these.

Duplicates can be identified as identical reads with identical mapping positions in shotgun sequencing data (i.e., randomly sheared whole genome data). 

* Note that RADseq reads intentionally start at identical positions to target the same loci and start from a restriction cut site, so you should generally not remove duplicates with RADseq data.

The MarkDuplicates command in [Picard](https://broadinstitute.github.io/picard/) can be used to remove duplicates from whole genome data.

**You can see an example Picard script for removing duplicates [here](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/picard.slurm)**

<br>

### Check mapping

Now you have mapped bam files with duplicates. Before or as you move on to variant calling you can run the `flagstat` command in [samtools](https://www.htslib.org/) to check how well your reads mapped to the reference.


**You can see an example samtools flagstat script [here](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/flagstat.slurm)**

This will give you an output file that looks like the one [here](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/R179199_flagstat.out)




<br>
<br>
<br>



## Variant calling

Once you have mapped your reads (and removed duplicates if desired), you can call variants. This process basically goes through your bam files and based on the reads that map to sites in the genome, assigns a call to each mapped site in the genome. E.g., if 10 reads mapped at a site are all "A", that will be called as A for that sample at that site. 

Most of the time, when you call variants you will call only variable site - that is, sites that have at least 2 (and often only exactly 2) alleles within your set of samples. So you will exclude sites where all samples have the same base, which massively saves disk space and excludes information that many population genetics programs won't use anyways.

* Some programs like [pixy](https://pixy.readthedocs.io/en/latest/), which calculates fst, dxy, and pi in windows across the genome, require that invariant sites are included in the final vcf


**You can see an example variant calling script using bcftools [here](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/var_call.slurm).**

This script runs a job array that calls variants separately for each chromosome to speed up calling. It is muc faster than calling variants across the whole genome at once, but requires some other setup we won't go into here.

**After calling variants you will want to sort each vcf file, as in [this script](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/sort_vcfs.slurm)**


**Then you can concatenate all of these vcf files for each individual scaffold into one large vcf file that contains all variants across the whole genome, as in [this script](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/combine_all_vcf.slurm)**

* Note that this script to combine is not a job array, because it needs to do a single job to combine all the vcf files, it can't be done on each independently


Note that there are multiple variant callers, this is just one way to do it and not necessarily the best way for your data.

<br>
<br>
<br>

## Variant filtering

Once you have your vcf file, you can filter it based on whatever criteria you like. For smaller files you can do this interactively, for large files, I use scripts.

**You can see an example filtering script [here](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/examples/filter_vcf.slurm)**

Instead of vcftools, you can use bcftools for filtering. It is faster and more powerful software, but the commands aren't quite as straightforward.



And remember that the way you filter vcf files will depend on the specific analyses you want to perform and the properties of your data.




<br><br><br>
<br><br><br>


[Home](https://github.com/seanharrington256/evoanalysis)

<br><br><br>
<br><br><br>
<br><br><br>
<br><br><br>