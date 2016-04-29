####################################################################################
#
#
#
#	Part 1  : Get the raw data
#
#
#
###################################################################################





#Download the fastq files for 

PR8_wsn33_download: data/raw/2014-5-30/SraRunInfo.csv
	cut -f1 -d ',' data/raw/2014-5-30/SraRunInfo.csv |grep -v "Run"|xargs fastq-dump --split-files -O data/raw/2014-5-30/
	python scripts/change_names_sra.py -s data/raw/2014-5-30/ -f data/raw/2014-5-30/ -k data/raw/2014-5-30/SraRunInfo.csv -run
20_mut_download: data/raw/2015-6-23/SraRunInfo.csv
	cut -f1 -d ',' data/raw/2015-6-23/SraRunInfo.csv |grep -v "Run"|xargs fastq-dump --split-files -O data/raw/2015-6-23/
	python scripts/change_names_sra.py -s data/raw/2015-6-23/ -f data/raw/2015-6-23/ -k data/raw/2015-6-23/SraRunInfo.csv -run
duplicate_download: data/raw/2015-11-14/SraRunInfo.csv
	cut -f1 -d ',' data/raw/2015-11-14/SraRunInfo.csv |grep -v "Run"|xargs fastq-dump --split-files -O data/raw/2015-11-14/
	python scripts/change_names_sra.py -s data/raw/2015-11-14/ -f data/raw/2015-6-23/ -k data/raw/2015-11-14/SraRunInfo.csv -run
# further changes names to what they were in the original analysis as to be consitant


#####################################################################################
#
#
#
#	Part 2  : Primary analysis - alignment, processing, and variant calling
#		This section relies heavily on a variant calling pipeline developed 
#		in Bpipe. It requires Bowtie2 and DeepSNV. The pipeline can be 
#		downloaded from https://github.com/lauringlab/variant_pipeline.git. 
#		The following commonands expect the variant_pipeline directory to be 
#		in your home directory.
#
#
#
#######################################################################################		 


PR8_wsn33_analysis : data/raw/2014-5-30/*.fastq
	python ~/variant_pipeline/bin/variantPipeline.py -i ./data/raw/2014-5-30/ -o ./data/process/2014-5-30/ -r ./data/reference/pHW2000_PR8-N_A -p PR8_control -d one.sided -m fisher -a 0.9	

20_mut_analysis : data/raw/2015-6-23/*.fastq
	python ~/variant_pipeline/bin/variantPipeline.py -i ./data/raw/2015-6-23/ -o ./data/process/2015-6-23/ -r ./data/reference/wsn33_wt_plasmid -p Plasmid_control -d two.sided -m fisher -a 0.9	
duplicate_analysis : data/raw/2015-11-14/*.fastq
	python ~/variant_pipeline/bin/variantPipeline.py -i ./data/raw/2015-11-14/ -o ./data/process/2015-11-14/ -r ./data/reference/wsn33_wt_plasmid -p WSN33_Plasmid_control.dups -d two.sided -m fisher -a 0.9


lofreq_analyis : ./data/process/2015-6-23/04_removed_duplicates/*.bam
	~/variant_pipeline/lib/bpipe-0.9.8.7/bin/bpipe run -n 3 ./scripts/lowfreq.bpipe.groovy ./data/process/2015-6-23/04_removed_duplicates/*.bam 




#####################################################################################
#
#
#
#	Part 3 : Secondary analysis make the figures!
#
#
#
#####################################################################################	




make_figures : /data/process/2014-5-30/Variants/all.sum.csv /data/process/2015-6-23/Variants/all.sum.csv /data/process/2015-11-14/Variants/all.sum.csv 
	Rscript -e "knitr::knit('./results/figures.Rmd')"	