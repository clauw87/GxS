library(data.table)
library(dplyr)


args <- commandArgs(T)

tmpfile <- args[1]
bedfile <- args[2]
outdir <- args[3]

# replace in situ  outputdir <- args[3]


tmp <- fread(tmpfile)
bed <- fread(bedfile)


for (chr_i in 1:22) {
tmp_chr <- filter(tmp, CHR==chr_i)
bed_chr <- filter(bed, chr==chr_i)
miss <- filter(tmp_chr, POS< min(bed_chr$start) | POS >  max(bed_chr$stop) )
for (snp in miss$SNPID) {
tmp <<- tmp[-which(tmp$SNPID == snp),]
}
}

#write.table(tmp, tmpfile, sep="\t", quote=F, row.names=F)

# gzip and replace
tmpfilename <- strsplit(basename(tmpfile), ".", fixed=T)[[1]][1]
fwrite(tmp, paste0(outdir, "/", tmpfilename, ".gz"), sep="\t", quote=F, row.names=F)
