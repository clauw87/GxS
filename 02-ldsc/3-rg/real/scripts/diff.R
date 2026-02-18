library(data.table)


args <- commandArgs(T)

out <- args[3]

all <- fread(args[1], header=F, sep=";")$V1
done <- fread(args[2], header=F, sep=";")$V1
new <- setdiff(all, done)

fwrite(as.data.frame(new), out, quote=F, sep="\t", col.names=F, row.names=F)
