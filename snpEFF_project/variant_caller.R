#load our library
library(dplyr)
library(BSgenome.Hsapiens.UCSC.hg19)
library(BSgenome)

# BSgenome.Hsapiens.UCSC.hg19
# genome <- BSgenome.Hsapiens.UCSC.hg19
# head(seqlengths(genome))
# genome$chr1 # same as genome[["chr1"]]
# 
# length(BSgenome.Hsapiens.UCSC.hg19)
# BSgenome.Hsapiens.UCSC.hg19
# length(BSgenome.Hsapiens.UCSC.hg19)

#change this to wherever you saved the github from
setwd(dir = "d:/github/Rani_Perasani/snEffect/Rani_Perasani/")
#import the report
uma<-read.table(file = "uma_example.txt",header = T,sep="\t")
head(uma)


#Optional
#Rename the chr, position start and stop for ease 
# uma$chr<-uma$Chrom
# uma$start<-uma$Position -1
# uma$end<-uma$Position-1 

#make a unique dataa frame that contains the values



del<-uma%>%select(Chrom,Position)
del$VarPosition<-del$Position-1
del$reflength<-width(uma$Ref)
del$delref<-del$Position-del$reflength 


#run the getSeq function to acquire the variant call
# and place into a s4 object called variant
variant<-getSeq(x=BSgenome.Hsapiens.UCSC.hg19,
                names=del$Chrom, 
                start=del$VarPosition, 
                end=del$VarPosition) 
variantdelref<-getSeq(x=BSgenome.Hsapiens.UCSC.hg19,
                      names=del$Chrom, 
                      start=del$delref, 
                      end=del$Position) 


#convert the s4 object to a dataframe
variant<-data.frame(variant)
variantdelref<-data.frame(variantdelref)
#overwrite the existing column in the uma df with the variant call
uma$Ref2<-variantdelref$variantdelref
uma$Variant<-variant$variant
library(tidyverse)
library(dplyr)
cbind(uma$Ref,uma$Ref2)

################This section of code with add the previous basepair to the Ref column######
uma$reflength<-width(uma$Ref)

uma$reflength





##################################################################
#If you dont want a duplicate, simply comment out this line of code
# Unite the columns ref and variant 
#Ref<-unite(data = uma,col = "Ref",Variant:Ref, sep = "")
#overwrite the existing ref column in uma with the united column
#uma$Ref<-Ref$Ref
###################################################################

#export this as a tsv file
write.table(uma,"uma_variant_called.tsv",row.names = F,sep = "\t")

