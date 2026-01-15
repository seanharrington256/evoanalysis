#!/bin/bash

#SBATCH --job-name bwa
#SBATCH -A evoanalysis
#SBATCH -t 0-12:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=64G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=YOUREMAIL@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /path/to/errout/err_BWA_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /path/to/errout/std_BWA_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array=1-32    # EDIT BASED ON HOW MANY SAMPLES

# Load necessary modules - MAKE SURE THESE ARE THE CURRENT VERSIONS WITH MODULE SPIDER
module load gcc/14.2.0 bwa/0.7.17 samtools/1.20


# GO TO YOUR DIRECTORY OF TRIMMED FASTQ FILES
cd /trimmed/fastq/directory

# Define the path to your reference genome
#  MAKE SURE YOU INDEXED IT BEFORE THIS SCRIPT OR MAPPING WILL FAIL!!
REF=/project/YOURPROJECT/SOMEPATH/referencegenome.fasta

# Make an output directoruy
OUTDIR=/project/YOURPROJECT/bwa_output
mkdir -p $OUTDIR

# Get a bash variable of all of the directories within the current directory
#    this works if you have one directory per sample, not if all samples are in a single directory
dirs=(*)

# Get a single sample, indexing by SLURM_ARRAY_TASK_ID
SAMPLE=${dirs[($SLURM_ARRAY_TASK_ID-1)]}


# move into sample directory
cd $SAMPLE

# Based on my specific sample name structure, get just the sample number from the file name
SAMP_ID=$(echo $SAMPLE | cut -d '_' -f 3)

#run bwa
bwa mem -M -t $SLURM_CPUS_PER_TASK $REF *_R1_* *_R2_* | samtools view - -b | samtools sort - -o $OUTDIR/${SAMP_ID}_sort.bam

# index the resulting bam file
samtools index -@ $SLURM_CPUS_PER_TASK $OUTDIR/${SAMP_ID}_sort.bam
