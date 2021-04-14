"this file takes the mut.gr genomic ranges object and produces a circle ideogram
the the specific deletion sites.  
Also this showcases the duplicate deletion on chr2:215821550"


library(GenomicRanges)
mut.gr <- with(uma, GRanges(Chrom, IRanges(Position, Position)))
mut.gr
data("hg19Ideogram", package = "biovizBase")
seqs <- seqlengths(hg19Ideogram)
seqlevels(hg19Ideogram)
## subset_chr
chr.sub <- c(paste("chr", 1:22,sep=""),"chrUn_gl000238","chrX")
# chr.sub<-c(1:22,"chrUn_gl000238","chrX")
class(chr.sub)
## levels tweak

seqlevels(mut.gr,pruning.mode=c("coarse"))<- chr.sub
seqlevels(mut.gr)
mut.gr <- keepSeqlevels(mut.gr, chr.sub)
mut.gr
seqs.sub <- seqs[chr.sub]
## assign_seqlengths
seqlengths(mut.gr) <- seqs.sub
## reanme to shorter names
new.names <- as.character(1:22)
names(new.names) <- paste("chr", new.names, sep = "")
new.names
mut.gr.new <- renameSeqlevels(mut.gr, new.names)
head(mut.gr.new)
#To get ideogram track, we need to load human hg19 ideogram data, for details please check another vignette about getting ideogram.
hg19Ideo <- hg19Ideogram
seqlevels(hg19Ideo)
hg19Ideo <- keepSeqlevels(hg19Ideo, chr.sub, pruning.mode = "coarse")
hg19Ideo <- renameSeqlevels(hg19Ideo, new.names)
head(hg19Ideo)
library(ggbio)
#basic circle
p <- ggplot() + #layout_circle(hg19Ideo, geom = "ideo", fill = "gray70", rank=1)+#radius = 6,trackWidth = 1
  layout_circle(hg19Ideo, geom = "scale", size = 3, rank=2)+# radius = 7, trackWidth = 2) + 
  layout_circle(hg19Ideo, geom = "text", aes(label = seqnames),size = 5,hjust=-0.01, vjust = 0,rank=3)+#radius = 11, trackWidth = 1) +  
  layout_circle(mut.gr, geom = "rect",stack=T, color = "firebrick4", size=1.5,rank=1, grid=T, grid.line="white", grid.background="grey80")#radius = 5,trackWidth = 1)
p

#########################################################
# NOTE: There is a duplication in the uma example at chromosome 2
library(dplyr)
chr2<-uma%>%filter(Chrom=="chr2")
chr2[13:14,1:16]
#Chrom  Position Ref Variant  Allele.Call Filter Frequency Quality Filter.1 Type Allele.Source Allele.Name Gene.ID Region.Name VCF.Position VCF.Ref
#chr2 215821550   A       - Heterozygous      -   58.7234 628.406        -  DEL            NA          NA      NA          NA    215821549      CA
#chr2 215821550  AA       - Heterozygous      -   41.2766 628.406        -  DEL            NA          NA      NA          NA    215821549     CAA


