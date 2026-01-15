#!/bin/bash

#SBATCH --job-name vcf_filt
#SBATCH -A evoanalysis
#SBATCH -t 0-3:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=24G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=YOUREMAIL@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /path/to/errout/err_filt_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /path/to/errout/std_filt_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)


#load packages - check that these are current
module load gcc/14.2.0 bcftools/1.20 vcftools/0.1.17

#go to directory
cd /project/yourproject/vcf_directory

# set up the inputs:
VCF_IN=your_genome.vcf.gz
VCF_OUT=filt_your_genome.vcf.gz




# Set up filters as bash variables to be called in the vcftools command
MAF=0  # set this to zero for correct calculation of pi & dxy and SFS
MISS=0.7
QUAL=30
MIN_DEPTH=7
MIN_ALLELES=2
MAX_ALLELES=2


# Apply those filters in vcftools
vcftools --gzvcf $VCF_IN \
	--remove-indels \
	--maf $MAF \
	--max-missing $MISS \
	--minQ $QUAL \
	--minDP $MIN_DEPTH \
	--min-alleles $MIN_ALLELES \
	--max-alleles $MAX_ALLELES \
	--recode --stdout | gzip -c > $VCF_OUT