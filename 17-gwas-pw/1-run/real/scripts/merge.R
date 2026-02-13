library(data.table)
library(dplyr)

args <- commandArgs(T)

uno_code <- args[1]
dos_code <- args[2]
suffix <- args[3]
indir <- args[4]
outdir <- args[5]



# test
#outdir="./real/tmp"
#uno_file <- "../08-coloc/0-munge/real/outputs/a8m.coloc-munged-sumstats.gz"
#uno_code <- gsub(".coloc-munged-sumstats.gz", "", basename(uno_file))


uno_file <- paste0(indir, "/", uno_code, suffix)
uno <- fread(uno_file)
uno <- uno[, c("SNP" , "CHR", "BP", "Z", "VAR_BETA")]
colnames(uno)[colnames(uno)=="Z"] <- paste0("Z", "_", uno_code)
colnames(uno)[colnames(uno)=="VAR_BETA"] <- paste0("V", "_", uno_code)



#dos_file <- "../08-coloc/0-munge/real/outputs/a9m.coloc-munged-sumstats.gz"
#dos_code <- gsub(".coloc-munged-sumstats.gz", "", basename(dos_file))


dos_file <- paste0(indir, "/", dos_code, suffix)
dos <- fread(dos_file)
dos <- dos[, c("SNP" , "CHR", "BP", "Z", "VAR_BETA")]
colnames(dos)[colnames(dos)=="Z"] <- paste0("Z", "_", dos_code)
colnames(dos)[colnames(dos)=="VAR_BETA"] <- paste0("V", "_", dos_code)


m <- merge(uno, dos, by=c("SNP", "CHR", "BP"))
colnames(m)[1:3] <- c("SNPID", "CHR", "POS")
m <- m[order(as.numeric(as.factor(m$CHR)),as.numeric(m$POS)),]


# save
m_name <- paste0(uno_code, ":", dos_code)
merge_file <- paste0(outdir, "/", m_name, ".", "gz")
write.table(m, gzfile(merge_file), sep="\t", row.names=F, quote=F)


