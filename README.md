# Advanced Evolutionary Analysis

<br>



<img src="images/justtextfiles.png" width="60%"/>

^ from the American Musem of Natural History Herpetology grad office

<br>

# Readings and Slides

- [Papers for class](https://github.com/seanharrington256/evoanalysis/blob/main/papers)
- [Slides from class](https://github.com/seanharrington256/evoanalysis/blob/main/Slides)

<br>

# Exercises 

- Day 1: [Unix shell exercise](https://swcarpentry.github.io/shell-novice/index.html)
- Day 2: [VCF, Population Structure, and Filtering exercise](sardines_tutorial/Sardines_tutorial.Rmd), or look at it in [PDF version](sardines_tutorial/Sardines_tutorial.pdf) for nicer formatting and [Data for this exercise](sardines_tutorial/data).
- [Day 2 Challenge](sardines_tutorial/Sardines_tutorial_part2.Rmd) (or the nicer looking [PDF Version](sardines_tutorial/Sardines_tutorial_part2.pdf))
- Jan 21: [Population structure in R](https://github.com/seanharrington256/evoanalysis/blob/main/Pop_structure_tutorial.Rmd). This uses the data file `/project/evoanalysis/data/petrochromis_data.vcf.gz` and if you'd like to dig into the metadata, `/project/evoanalysis/data/Petro_metadata.csv`
- [Week 3 Challenge](Week_3_Challenge.pdf)

<br>



Sean's challenge 1 solutions are available [here](https://github.com/seanharrington256/evoanalysis/tree/main/challenge_1_solution/SeansSolutions_challenge1.md).



Sean's challenge 3 solutions are available [here](https://github.com/seanharrington256/evoanalysis/tree/main/challenge_3_solution). `seans_challenge_3_cmd.md` shows development of the code interactively, `seans_challenge_3_single.slurm` takes that and puts it into a slurm file that runs on a single fastq file, `seans_challenge_3_array.slurm` then modifies the previous into an array job. 




<br>

# Resources

A general introduction to to UW's MedicineBow computing cluster:

- [MedicineBow tutorial](https://github.com/seanharrington256/evoanalysis/blob/main/medbow_tutorial/medbow_tutorial.md)


An introduction to to RStudio on MedicineBow:

- [RStudio on MedBow](https://github.com/seanharrington256/evoanalysis/blob/main/R_medbow_tutorial/r_medbow_tutorial.md)


An introduction to git and Github:

- [git & Github tutorial](https://github.com/seanharrington256/evoanalysis/blob/main/git_tutorial/Intro_git.md)


An overview of read quality control, mapping, and variant calling:

- [Mapping, QC, variant calling tutorial](https://github.com/seanharrington256/evoanalysis/blob/main/map_call_tutorial/map_call.md)



<br>
<br>

Other online resources that will be useful as we work through course material: 

- [Speciation Genomics Workshop (Meier and Ravinet)](https://speciationgenomics.github.io/)
- [Pixy](https://github.com/ksamuk/pixy) a command-line tool for painlessly computing unbiased estimators of population genetic summary statistics that measure genetic variation within (π, θW, Tajima’s D) and between (dxy, FST) populations from a VCF
- A great [GEA tutorial](https://bookdown.org/hhwagner1/LandGenCourse_book/WE_11.html)
- [LFMM in LEA (in R)](https://www.bioconductor.org/packages/devel/bioc/vignettes/LEA/inst/doc/LEA.pdf)
- Jessica Rick's [Reich Fst estimator implementation](https://github.com/jessicarick/reich-fst) (good for small sample sizes)



Some tutorials Sean made for Google Cloud. The R and other analyses are not specific to the cloud, just ignore cloud-specific stuff if running on MedicineBow or locally:

- [Population structure in R, including plotting maps](https://github.com/wyoibc/RADseq_cloud_learn/blob/master/2_popstructR.ipynb)
- [Phylogenetic analysis](https://github.com/wyoibc/RADseq_cloud_learn/blob/master/4_plot_phylo.ipynb)




<br>

# Course Information

- [Syllabus v1](https://github.com/seanharrington256/evoanalysis/blob/main/Advanced_Evolutionary_Analysis_Syllabus_v1.pdf)
