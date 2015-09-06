suppressPackageStartupMessages({
    library(cnv)
})


options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

draw <- read.delim(args[1])
data <- subset(draw,draw$cnv.size > 5000)
cnvset <- cnv.print(data)
data$chromosome <- gsub("Supercontig_1","SC",data$chromosome)
cnv.summary(data)

splitvec <- strsplit(args[1],".",fixed=TRUE)[[1]]
base <- head(splitvec[1],n=1)
outfile <- paste(base, "csv",sep=".")
outimg <- paste(base,"5kb","pdf",sep=".")

#write.csv(cnvset,outfile)
pdf(outimg)
plot.cnv(data)
