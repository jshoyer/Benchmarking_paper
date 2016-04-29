# Benchmarking_paper

This repository holds the analysis used in *McCrone and Lauring,2016* it relies heavily on our other repo variant_pipeline. I'll be working in the next few days to make the analysis easier to follow. But certainly it's all here. -JT



Overview
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

    +- Makefile        # executable Makefile for this study, if applicable
    
    
  
