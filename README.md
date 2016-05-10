# Benchmarking_paper

This repository holds the analysis used in *McCrone and Lauring,2016* it relies heavily on our other repo variant_pipeline.

Disclaimer :  Currently the analysis can be reliably reproduced using the commands in the Makefile and the original fastq files; however, there is a slight issue with using the fastq files downloaded from the SRA. This does not change any of the conclusions in the paper, but results in minor changes in some figure tables. The issue is due to the fact that the SRA does not save read names. In our analysis we use Picard MarkDuplicates to remove all duplicates including optical duplicates. Optical duplicates are identified at least in part based on their position relative to other reads on the flow cell. This information is stored in the read name and is lost when the fastq files are downloaded from the SRA. The SRA plans to correct this in the future, but for the time being it is out of our hands, and we apologize for any inconvience it may cause. 


#Overview
--------

    project
    |- README          # the top level description of content
    |
    |- data            # raw and primary data, are not changed once created
    |  |- reference/  # reference files to be used in analysis
    |  |- raw/         # raw data, will not be altered
    |  |- process/     # cleaned data, will not be altered once created
    |
    |- scripts/           # any programmatic code
    |- results         # all output from workflows and analyses
    |  |- tables/      # tables made from the anaylis - may not render nicely
    |  |- figures/     # graphs, likely designated for manuscript figures
    |  |- figures.Rmd  # exicutable R markdown to make the figures 
    |  +- pictures/    # diagrams, images, and other non-graph graphics

    +- Makefile        # executable Makefile for this study
    
  --------
# Dependencies    
The analysis expects you to have the variant_pipeline repository cloned and saved in your home directory.
```
    cd ~/
    git clone https://github.com/lauringlab/variant_pipeline.git
```
This pipeline requires [fastqc](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/), [bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml) and the R package [DeepSNV](https://www.bioconductor.org/packages/release/bioc/html/deepSNV.html).

Information on the dependencies needed to run the varaint\_pipline can be found [here](https://github.com/lauringlab/variant_pipeline)


The lofreq analysis also requires that you download [Lofreq\*](csb5.github.io/lofreq). The script lofreq.bpipe.groovy looks for lofreq to be in a lib directory. The command looks for the exicutables in ./lib/lofreq_star-2.1.2/bin/. 

The session information on the Rmarkdown file that reproduces the figures is below.
```
 R version 3.2.3 (2015-12-10)
    ## Platform: x86_64-apple-darwin13.4.0 (64-bit)
    ## Running under: OS X 10.10.5 (Yosemite)
    ##
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ##
    ## attached base packages:
    ##  [1] grid      stats4    parallel  stats     graphics  grDevices utils
    ##  [8] datasets  methods   base
    ##
    ## other attached packages:
    ##  [1] xtable_1.8-2        knitr_1.12.27       png_0.1-7
    ##  [4] gtable_0.2.0        cowplot_0.6.2       gridExtra_2.2.1
    ##  [7] pROC_1.8            reshape2_1.4.1      Biostrings_2.36.4
    ## [10] XVector_0.8.0       IRanges_2.2.9       S4Vectors_0.6.6
    ## [13] BiocGenerics_0.14.0 plyr_1.8.3          ggplot2_2.1.0
    ##
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.4      magrittr_1.5     zlibbioc_1.14.0  munsell_0.4.3
    ##  [5] colorspace_1.2-6 stringr_1.0.0    tools_3.2.3      htmltools_0.3.5
    ##  [9] yaml_2.1.13      digest_0.6.9     formatR_1.3      codetools_0.2-14
    ## [13] evaluate_0.9     rmarkdown_0.9.6  labeling_0.3     stringi_1.0-1
    ## [17] scales_0.4.0


```

#Reproducing the analysis

We can use the commands in the Makefile to do everyhing from download the fastq files from the SRA all the way through making the figures. The Makefile contains comments that may be useful if you run into problems.

## Downloading raw data
The following commands download the necessary .sra files into the default directory ~/ncbi/public/sra/,  move and convert them to fastq files in the appropriate data/raw directory and remove the .sra file. These targets also give the fastq files meaningful names based on the meta data avaialable from the SRA.

```
    make data/raw/2014-5-30/%.fastq
    make data/raw/2015-6-23/%.fastq
    make data/raw/2015-11-14/%.fastq
    
```

## Processing the raw data

The following commands launch the analyis pipeline from https://github.com/lauringlab/variant_pipeline. This pipeline is based in [bpipe](http://bpipe-test-documentation.readthedocs.io/en/latest/) and is smart enough to remember what commands have been run in the event of failure. It also logs the commands that were run. These steps are time and memory intensive.

```
make ./data/process/2014-5-30/Variants/all.sum.csv
make ./data/process/2015-6-23/Variants/all.sum.csv
make ./data/process/2015-11-14/Variants/all.sum.csv
make ./data/process/2015-6-23.one.sided/Variants/all.sum.csv
make ./data/process/2015-6-23/Lofreq/lofreq_vcf/all.lofreq.csv
```

## Making the figures

I usually knit the RMD in R studio; however it should be possible using the following commands. Note : *I'm not sure how these commands work in the context of making a github_document output. You can change this line in figures.Rmd as needed.*

```
make ./results/figures.md
```


