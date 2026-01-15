#!/bin/bash

#SBATCH --job-name fastqcount
#SBATCH -A evoanalysis
#SBATCH -t 0-00:10
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sharrin2@uwyo.edu
#SBATCH -e /project/evoanalysis/sharrin2/scripts/err_out/err_fastqcount_%A.err	
#SBATCH -o /project/evoanalysis/sharrin2/scripts/err_out/std_fastqcount_%A.out	





#Define an input file to work with:

FASTQ="/project/evoanalysis/d3challenge_fq/PBMLT02_171.combined_final.fastq"



#Create an output directory to write output to:

OUTDIR="/project/evoanalysis/sharrin2/challenge3"
mkdir -p $OUTDIR


#Get the base filename without the full path:


FILENAME=$(basename $FASTQ)


# replace the $FILENAME variable with just the sample name
FILENAME=$(echo $FILENAME | cut  -d "." -f 1)


#Define a full output file path:

OUTFILE="${OUTDIR}/${FILENAME}_numreads.txt"



# Then write the file


echo "Number of reads:" > $OUTFILE
grep -c '^+$' $FASTQ >> $OUTFILE









