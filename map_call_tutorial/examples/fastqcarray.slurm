#!/bin/bash

#SBATCH --job-name fastqc
#SBATCH -A evoanalysis  ## EDIT TO YOUR PROJECT
#SBATCH -t 0-01:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=10G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=YOUREMAIL@uwyo.edu   # EDIT TO YOUR EMAIL
#SBATCH -e /path/to/errout/err_fastqc_%A_%a.err # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /path/to/errout/std_fastqc_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array=1-16    # EDIT BASED ON HOW MANY SAMPLES

#load fastqc
module load fastqc/0.12.1 

#change directory to trimmed data
cd /project/milksnake/trim_fastq2

OUTDIR="/cluster/medbow/project/evoanalysis/YOUR_DIRECTORY" # EDIT TO WHERE YOU WANT OUTPUT TO GO
mkdir -p $OUTDIR

#assign all files samples, each of which is in its own directory into a bash array
allsamples=(*/)


# Use the SLURM_ARRAY_TASK_ID to select a single sample out of the bash array
#  I use ($SLURM_ARRAY_TASK_ID-1) because bash indexing starts at 
#     zero and this is easier for me to keep track of.
sample=${allsamples[($SLURM_ARRAY_TASK_ID-1)]}

# change to directory into sample and run fastqc 
cd $sample 
fastqc -t 2 -o $OUTDIR *fastq.gz
