#########################################################################
#
#
#
#	Part 1  : Get the raw data
#
#
#
#########################################################################





#Download the fastq files for 

##PR8-WSN33 data set

PR8_wsn33_download:
	cut -f1 -d ',' data/raw/2014-5-30/SraRunInfo.csv |grep -v "Run"|xargs fastq-dump --split-files -O data/raw/2014-5-30/
	python scripts/change_names_sra.py -s data/raw/2014-5-30/ -f data/raw/2014-5-30/ -k data/raw/2014-5-30/SraRunInfo.csv -run
20_mut_download:
	cut -f1 -d ',' data/raw/2015-6-23/SraRunInfo.csv |grep -v "Run"|xargs fastq-dump --split-files -O data/raw/2015-6-23/
	python scripts/change_names_sra.py -s data/raw/2015-6-23/ -f data/raw/2015-6-23/ -k data/raw/2015-6-23/SraRunInfo.csv -run
duplicate_download:
	cut -f1 -d ',' data/raw/2015-11-14/SraRunInfo.csv |grep -v "Run"|xargs fastq-dump --split-files -O data/raw/2015-11-14/
	python scripts/change_names_sra.py -s data/raw/2015-11-14/ -f data/raw/2015-6-23/ -k data/raw/2015-11-14/SraRunInfo.csv -run




