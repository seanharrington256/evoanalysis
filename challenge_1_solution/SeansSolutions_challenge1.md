## Sean's solutions to Unix challenge 1

Have a look at Sean's .fastq file that we looked at together in class (attached here). Given this FASTQ file, figure out, using command line tools only:

1. How many reads it contains

2. The length of the longest sequence

3. Save the results to a file

4. Upload your code to the WyoCourses assignment in a text file showing how you accomplished these challenges. 


<br>


### Solutions:

- How many reads??


I count reads using the spacer (+):

```
grep -c '^+' AMCC264757_R1_downsamp.fastq 
```

should return 10000


the `-c` option in `grep` counts the number of matching lines. `'^+'` searches for a `+` at the beginning of the line, where line start is designated by `^`.

Note that this is not a perfect method because `+` is also a possible quality score, and a read's quality score line could start with this. It's therefore better to use:

```
grep -c '^+$' AMCC264757_R1_downsamp.fastq 
```

Where `$` denotes the end of the line, so this will count only lines that contain `+` and nothing else, which works for all modern fastq files I've encountered, although will not work if the spacer line has any other characters in it.

This also did not work with this file until I changed the encoding to change end of line characters to Unix from Windows (probably an artifact of the fact that I generated this fastq a decade ago when I used a Windows machine).



2. The length of the longest sequence


Using tools from class:

```
grep -B 1 '^+' AMCC264757_R1_downsamp.fastq
grep -B 1 '^+' AMCC264757_R1_downsamp.fastq | wc -L
```

Using awk:

https://stackoverflow.com/questions/16750911/count-line-lengths-in-file-using-command-line-tools

https://stackoverflow.com/questions/9968916/print-every-nth-line-into-a-row-using-gawk

```
awk 'NR%4==2' AMCC264757_R1_downsamp.fastq  # get 2nd line and every 4th after

awk '{print length}' AMCC264757_R1_downsamp.fastq  # get length of each line
```


combined

```
awk 'NR%4==2 {print length}' AMCC264757_R1_downsamp.fastq
```


get unique and sort:

```
awk 'NR%4==2 {print length}' AMCC264757_R1_downsamp.fastq | uniq | sort -n
```





3. Save the results to a file



```
# print num reads:

echo "Number of reads:" > fastqstats.txt
grep -c '^+' AMCC264757_R1_downsamp.fastq >> fastqstats.txt

echo "Longest read:" >> fastqstats.txt
awk 'NR%4==2 {print length}' AMCC264757_R1_downsamp.fastq | uniq | sort -n >> fastqstats.txt
```

