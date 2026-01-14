#!/bin/bash

#SBATCH --job-name=fastp
#SBATCH -A evoanalysis
#SBATCH -t 0-12:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24  
#SBATCH --mem=16G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=YOUREMAIL@uwyo.edu       # EDIT TO YOUR EMAIL
#SBATCH -e /path/to/errout/err_trim_%A_%a.err   # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH -o /path/to/errout/std_trim_%A_%a.out   # EDIT TO YOUR DIRECTORY IN evoanalysis (or wherever else)
#SBATCH --array=1-16     # EDIT BASED ON HOW MANY SAMPLES

# Load fastp module
module load fastp/0.23.4

# Define paths   - EDIT TO YOUR PATHS
RAW_DIR="/PATH/TO/raw_fastq2"
OUTDIR="/PATH/TO/trim_fastq2"
REPORTDIR="/PATH/TO/fastp_reports"
ADAPTERS="/PATH/TO/adapters.fa"   # if using a file of adapters not just defaults

# Ensure output directories exist
mkdir -p "$OUTDIR" "$REPORTDIR"

# Get all subdirectories (samples) - here each pair of reads is in a separate sample directory
cd "$RAW_DIR"
dirs=(*/)

# Change into a single sample directory using SLURM_ARRAY_TASK_ID to index
sample_dir="${dirs[$SLURM_ARRAY_TASK_ID-1]}"
cd "$sample_dir"

# Extract sample name (remove trailing slash and use as ID) - this depends on exactly how your files are named
SAMPLE=$(basename "$sample_dir" | cut -f1 -d'_')

# Define input and output files - this assumes that there are ONLY 1 R1 and 1 R2 in the current directory
FORWARD=$(ls *_R1_*.fastq.gz)
REVERSE=$(ls *_R2_*.fastq.gz)

# Define an output directory for this specific sample
OUT_SAMPLE="${OUTDIR}/trim_read_${SAMPLE}"
mkdir -p "$OUT_SAMPLE" # make the directory

# Make names for the output files
O_FOR="${OUT_SAMPLE}/${SAMPLE}_R1_trimmed.fastq.gz"
O_REV="${OUT_SAMPLE}/${SAMPLE}_R2_trimmed.fastq.gz"
REPORT_JSON="${REPORTDIR}/${SAMPLE}_fastp.json"
REPORT_HTML="${REPORTDIR}/${SAMPLE}_fastp.html"

# Run fastp
fastp -i "$FORWARD" -I "$REVERSE" \
      -o "$O_FOR" -O "$O_REV" \
      -h "$REPORT_HTML" -j "$REPORT_JSON" \
      --length_required 70 \
      --adapter_fasta "$ADAPTERS" \
      --detect_adapter_for_pe \
      --correction \
      --trim_poly_g --trim_poly_x \
      --qualified_quality_phred 20 \
      --unqualified_percent_limit 30 \
      --n_base_limit 5 \
      --cut_window_size 4 --cut_mean_quality 20 --cut_right \
      -w "$SLURM_CPUS_PER_TASK"
