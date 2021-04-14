"This Rscript writes the genomic ranges object and produces the 
positions table with the minus and plus strand calls"



library(BSgenome.Hsapiens.UCSC.hg19)
genome <- BSgenome.Hsapiens.UCSC.hg19
setwd(dir = "d:/github/Rani_Perasani/snEffect/Rani_Perasani/")
#import the report
uma<-read.table(file = "uma_example.txt",header = T,sep="\t")
head(uma)
uma$Position
del$start
## Load the Caenorhabditis elegans genome (UCSC Release ce2):
library(BSgenome.Hsapiens.UCSC.hg19)

## Look at the index of sequences:
genome<-BSgenome.Hsapiens.UCSC.hg19

variant_minus<-getSeq(genome, uma$Chrom,
       start=uma$Position, end=uma$Position, strand="-")
variant_minus_df<-as.data.frame(variant_minus)
variant_plus<-getSeq(genome, uma$Chrom,
       start=uma$Position, end=uma$Position, strand="+")
variant_plus_df<-as.data.frame(variant_plus)

## ---------------------------------------------------------------------
## C. USING A GRanges OBJECT
## ---------------------------------------------------------------------

mut.gr #how did I make mut.gr again?
genome

gr1<-getSeq(genome, mut.gr)  # treats strand values as if they were "+"
gr1
gr1_df<-as.data.frame(gr1)
tmp<-cbind(gr1_df,variant_minus_df,variant_plus_df)
tmp

#The variant_minus_df is wrong, the variant plus df and the mut.gr are correct
positions<-paste(uma$Chrom,":",uma$Position, sep="")
positions

positions2<-cbind(positions,tmp)
colnames(positions2)<-c("positions","minus",'plus',"mut.gr")
positions2$mut.gr<-NULL
positions2

write.table(positions2,"positions.txt",row.names = F,col.names = T,quote = F,sep = "\t")
