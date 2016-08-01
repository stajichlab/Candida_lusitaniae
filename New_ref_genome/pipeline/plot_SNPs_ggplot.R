library(ggplot2)
path="/bigdata/stajichlab/shared/projects/Candida/HMAC/Clus_reseq/New_ref_assembly"

file.names <- dir(path,pattern=".SNPONLY.vcf$")
file.names
for(i in 1:length(file.names)){
base=strsplit(file.names[i],"[.]vcf")
pdf(paste(base[1],"_snp_density.pdf",sep=""))
snps<-read.table(file.names[i],sep="\t",header=F,blank.lines.skip=TRUE,
                 comment.char = "#")
colnames(snps)<-c("chr","start","id","refallele","altallele","qual",
                  "filter","info","format")

ctg <- snps$chr
okctgs <- ctg %in% grep("ctg_[123456]$", ctg, value = TRUE)
snps <- subset(snps,okctgs)

#feats <- read.table("chrom_features.dat",sep="\t",header=T,
#                   comment.char = "#", blank.lines.skip=TRUE)
#colnames(feats) <- c("chr","type","start","end")
#summary(feats)
#summary(snps)
# put the chromosomes in the good order: chr1, chr2, chr22, chrX
goodChrOrder <- c(paste("S9.L3D_ctg_",c(1:6),sep=""))
snps$chr <- factor(snps$chr,levels=goodChrOrder)
#feats$chr <- factor(feats$chr,levels=goodChrOrder)

title <- paste("Density of SNPs in " ,file.names[i])
# Plot the densities of snps in the bed file for each chr seperately
snpDensity<-ggplot(snps) + 
geom_histogram(aes(x=start),binwidth=1e4) + # pick a binwidth that is not too small 
facet_wrap(~ chr,ncol=2) + # seperate plots for each chr, x-scales can differ from chr to chr
ggtitle(title) +
xlab("Position in the genome") + 
ylab("SNP density") + 
theme_bw() # I prefer the black and white theme

snpDensity 
#geom_text(data=feats,aes(x=start,y=5,label=type))+facet_wrap(~ chr,ncol=2)
# save the plot to .pdf file
print(snpDensity)
}
#dev.off()

