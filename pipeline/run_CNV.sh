library(cnv)
data <- read.delim("Sample2.hits-vs-Sample1.hits-0.6.pvalue-0.001.minw-4.cnv")
cnv.print(data)
cnv.summary(data)

#plot.cnv(data, CNV=4, upstream=4e+6, downstream=4e+6)
#ggsave("100Hw.test.CNV.pdf")
