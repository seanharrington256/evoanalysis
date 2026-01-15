Develop functional code that makes the file with counted number of reads (hint: you should have this from the first challenge)
Put that into a slurm script that works on a single fastq file
Once 2 works, expand that to a job array that works over all the fastq files




## print num reads on the command line:


Define an input file to work with:

```
FASTQ="/project/evoanalysis/d3challenge_fq/PBMLT02_171.combined_final.fastq"
```

Count the number of reads in that to the screen as a test:

```
grep -c '^+$' $FASTQ
```

Create an output directory to write output to:

```
OUTDIR="/project/evoanalysis/sharrin2/challenge3"
mkdir -p $OUTDIR
```

Get the base filename without the full path:


```
FILENAME=$(basename $FASTQ)

echo $FILENAME   #check that worked

#If you want, cut off everything after the first period to get just sample ID - not strictly necessary:


# check my cut command first:
echo $FILENAME | cut  -d "." -f 1

# replace the $FILENAME variable with that
FILENAME=$(echo $FILENAME | cut  -d "." -f 1)
```

Define a full output file path:

```
OUTFILE="${OUTDIR}/${FILENAME}_numreads.txt"


# check it looks good:
echo $OUTFILE
```

Then

```
echo "Number of reads:" > $OUTFILE
grep -c '^+$' $FASTQ >> $OUTFILE
```

Check that worked:


```
cat $OUTFILE
```



Then go develop that into a single slurm script, then as a job array after that works.





