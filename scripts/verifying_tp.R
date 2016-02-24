require(plyr)
sum.1<-read.csv("~/Desktop/adams_data/SeptA.sum.csv",stringsAsFactors = F)
sum.1$Id[sum.1$Id=="NA_36"]<-"NA_26" #corrects a typo in the file naming scheme
sum.2<-read.csv("~/Desktop/adams_data/SeptB.sum.csv",stringsAsFactors = F)
sum.2<-mutate(sum.2, Id=sub("-","_",Id))
sum.3<-read.csv("~/Desktop/adams_data/JuneA.sum.csv",stringsAsFactors = F)
sum.4<-read.csv("~/Desktop/adams_data/Shawn1.sum.csv",stringsAsFactors = F)
sum.4<-mutate(sum.4, Id=sub("-","_",Id))
tp<-read.csv("~/Desktop/Benchmarking_paper/data/reference/mutant_id.csv")

sum.1$run="SeptA"
sum.2$run="SeptB"
sum.3$run="JuneA"
sum.4$run="Shawn1"

sum.df<-rbind(sum.1,sum.2)
sum.df<-rbind(sum.df,sum.3)
sum.df<-rbind(sum.df,sum.4)

sum(unique(sum.df$Id) %in% tp$Id) # checks that we have all 20

## now let's subset

cut.df<-subset(sum.df, Id %in% tp$Id & p.val<0.01 & MapQ>30 & Phred>35 & Read_pos>62 & Read_pos<188 )
cut.df<-mutate(cut.df,category=mutation %in% tp$mutant)


subset(cut.df, category==F )

#There are some overlaps so I'll remove those now.


