#load our library
library(dplyr)
library(BSgenome.Hsapiens.UCSC.hg19)
library(BSgenome)

BSgenome.Hsapiens.UCSC.hg19
genome <- BSgenome.Hsapiens.UCSC.hg19
head(seqlengths(genome))
genome$chr1 # same as genome[["chr1"]]

length(BSgenome.Hsapiens.UCSC.hg19)
BSgenome.Hsapiens.UCSC.hg19
length(BSgenome.Hsapiens.UCSC.hg19)
setwd(dir = "d:/github/Rani_Perasani/snEffect/Rani_Perasani/")
#import the report
uma<-read.table(file = "uma_example.txt",header = T,sep="\t")
head(uma)


#OPtional
#Rename the chr, position start and stop for ease 
# uma$chr<-uma$Chrom
# uma$start<-uma$Position -1
# uma$end<-uma$Position-1 

#make a unique dataa frame that contains the values

#UPDATE: THIS COULD BE WHY THE CALLS WERE WRONG
#INSTEAD OF SELECTING THE POSITION, WE SELECTED THE POSITION -1
#SO ITS NO SUPRISE THAT WHEN HE CHECKED AGAINST THE UCSC MAIN TABLE BROWSER
# THERE WASNT A MATCH AT THE DELETION SITE

del<-uma%>%select(Chrom,Position)
del$Position<-del$Position
del


#run the getSeq function to acquire the variant call
# and place into a s4 object called variant
variant<-getSeq(x=BSgenome.Hsapiens.UCSC.hg19,
                names=del$Chrom, 
                start=del$Position, 
                end=del$Position) 
variant
#convert the s4 object to a dataframe
variant<-data.frame(variant)

#overwrite the existing column in the uma df with the variant call
uma$Variant<-variant$variant
library(tidyverse)
library(dplyr)

##################################################################
#If you dont want a duplicate, simply comment out this line of code
# Unite the columns ref and variant 
Ref<-unite(data = uma,col = "Ref",Variant:Ref, sep = "")
#overwrite the existing ref column in uma with the united column
uma$Ref<-Ref$Ref
###################################################################


#export this as a tsv file
write.table(uma,"uma_variant_called.tsv",sep = "\t")

