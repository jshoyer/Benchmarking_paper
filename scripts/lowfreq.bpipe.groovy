
done = { 
    exec "date"
    exec "echo variantPipeline SUCCESS"
}


lofreq= {
    doc "runs lofreq on out of the box conditions"
    output.dir = "./data/process/2015-6-23/Lofreq/variants"
    transform(".vcf"){
        exec "./lib/lofreq_star-2.1.2/bin/lofreq call -f ./data/reference/wsn33_wt_plasmid.fa -o $output.vcf $input.bam"
        }   
}

mapq_vcf = {
	doc "updates the lofreq vcf adding the average MapQ,Phred, and read position of each variant"
	output.dir = "./data/process/2015-6-23/Lofreq/vcf_quality"
	def vcf = file(input.vcf).name.replace(".vcf","")
        def bam = file(input.bam).name.replace(".bam","")
	if ( vcf == bam) {
                println "Found match: " + vcf + ".vcf and " +bam+".bam"
                filter("mapq_vcf"){
        			}
                       exec " python ./scripts/mapq_vcf.py $input.vcf $input.bam $output.vcf"
        } else {
               	println "vcf: " + vcf + " doesn't match bam: "+bam
        }
}



vcf_csv = {
	doc "converts lofreq vcf into csv that is compatable with the R analysis used to parse deepSNV results"
	output.dir = "./data/process/2015-6-23/Lofreq/lofreq_csv"
	transform(".csv"){
		exec " python ./scripts/vcf_csv.py $input.vcf $output.csv"
	}
}

combine_all = { doc "concatenates all the lofreq csv files into one"
	exec "python ./scripts/combine_vcf.csv.py ./data/process/2015-6-23/Lofreq/lofreq_csv/  mapq_vcf.csv  all.lofreq.csv"

}


run { 
    
  "%.bam" * [lofreq+ "%.vcf"*[mapq_vcf]] +
  "%.vcf"*[vcf_csv]+ combine_all +  
     done
}
