#!/bin/bash

#SBATCH --job-name flagstat
#SBATCH -A evoanalysis
#SBATCH -t 0-36:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=14
#SBATCH --mem=40G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=YOUREMAIL@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /path/to/errout/bwa_errs_outs/err_flagstat_%A_%a.err  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /path/to/errout/bwa_errs_outs/std_flagstat_%A_%a.out  # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array 1-32    # EDIT BASED ON HOW MANY SAMPLES



# load modules necessary - check that these are current versions
module load gcc/14.2.0 samtools/1.20


# Set the path to your reference genome
REF=/project/YOURPROJECT/SOMEPATH/referencegenom.fasta

# Set up an output directory and create it
OUTDIR=/project/YOURPROJECT/flagstat_out
mkdir -p $OUTDIR


# Set working directory to where the sorted reads are

cd /project/milksnake/bwa_milksnake_2
#array of files

bams=(*.bam)

SAMPLE=${bams[($SLURM_ARRAY_TASK_ID-1)]}
#output file name
name=$(echo $SAMPLE| cut -d '_' -f 1)

#run
samtools flagstat -@ $SLURM_CPUS_PER_TASK $SAMPLE > $OUTDIR/${name}_flagstat.out




