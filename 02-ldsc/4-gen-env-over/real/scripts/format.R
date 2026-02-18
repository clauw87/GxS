library(data.table)



args <- commandArgs(trailingOnly=TRUE)

file <- args[1]


res <- fread(file)

res$trait1 <- gsub(".munged-sumstats.gz", "",  gsub("../1a-munge/real/outputs/", "", res$p1))
res$trait2 <- gsub(".munged-sumstats.gz", "",  gsub("../1a-munge/real/outputs/", "", res$p2))



write.table(res, file, sep="\t", row.names=FALSE, col.names=TRUE, quote=FALSE)
