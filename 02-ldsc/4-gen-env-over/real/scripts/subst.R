library(data.table)


args <- commandArgs(trailingOnly=TRUE)


file <- args[1]
out <- "./real/outputs/all_env_gen.txt"

final <- fread(file)
final$envcov <- final$gcov_int - final$gencov


# overwrite tmp file for trait
write.table(final, out, sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)
