#!/bin/bash

#SBATCH --job-name BWA_milk
#SBATCH -A milksnake
#SBATCH -t 0-12:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=64G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kwelch15@uwyo.edu
#SBATCH -e /project/milksnake/scripts/err_out/bwa_errs_outs/err_BWA_rat_%A_%a.err
#SBATCH -o /project/milksnake/scripts/err_out/bwa_errs_outs/std_BWA_rat_%A_%a.out
#SBATCH --array=1-16


module load gcc/14.2.0 bwa/0.7.17 samtools/1.20

cd /project/milksnake/trim_fastq

#New ref for population loci assesment and later annotation
REF=/project/milksnake/ref_genome/ratsnake_scaffold/P_alleghaniensis_concatenate_ragtag.scaffolds.fasta


OUTDIR=/project/milksnake/bwa_milksnake
mkdir -p $OUTDIR

dirs=(*)


SAMPLE=${dirs[($SLURM_ARRAY_TASK_ID-1)]}


#call directory
cd $SAMPLE


SAMP_ID=$(echo $SAMPLE | cut -d '_' -f 3)

#run bwa
bwa mem -M -t $SLURM_CPUS_PER_TASK $REF *_R1_* *_R2_* | samtools view - -b | samtools sort - -o $OUTDIR/${SAMP_ID}_sort.bam

samtools index -@ $SLURM_CPUS_PER_TASK $OUTDIR/${SAMP_ID}_sort.bam
