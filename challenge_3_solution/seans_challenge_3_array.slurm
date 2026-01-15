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
#SBATCH --array=1-38



## go into directory of interest:

cd "/project/evoanalysis/d3challenge_fq/"

# create a bash array with all of the fastq files in it:
ALLFASTQ=(*fastq)

## While writing this, test out (uncommented on the comand line:)
# ALLFASTQ=(*fastq)
# echo ${ALLFASTQ[@]}
### looks good




#Define a single input file to work with:
FASTQ=${ALLFASTQ[($SLURM_ARRAY_TASK_ID-1)]}


### While writing this, test out on the command line:
# SLURM_ARRAY_TASK_ID=2
# FASTQ=${ALLFASTQ[($SLURM_ARRAY_TASK_ID-1)]}
# echo $FASTQ

# looks good


#Create an output directory to write output to:
### I WOULD USUSALLY MOVE THIS UP TOP TO WHERE HARD-CODED VARIABLES/PATHS ARE
###   LEAVING IT HERE TO SHOW HOW SIMILAR SINGLE AND ARRAY SCRIPTS ARE
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









