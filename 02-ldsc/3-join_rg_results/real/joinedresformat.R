library(data.table)
library(dplyr)
library(stringr)
library(xtable)


args <- commandArgs(T)

res_file <- args[1]
meta_file <- args[2]
powered_file <- args[3]

# Results file
rg <- fread(res_file)
colnames(rg)[1:2] <- c("Trait1", "Trait2")

# Metadata file
meta <- fread(meta_file)

# Powered (both sexes h2 Z>2) sids
powered_ids <- fread(powered_file, header=F)$V1
# Filter to metadata ones, filter to general powered (Z2) ones 
rg <- filter(rg, Trait1 %in% meta$sid & Trait2 %in% meta$sid)
rg <- filter(rg , Trait1 %in% powered_ids, Trait2 %in% powered_ids)


# Format
rg$Trait1_name <- sapply(rg$Trait1, function(s) { as.character(unique(filter(meta, sid ==s)$uniqValue)) })
rg$Trait2_name <- sapply(rg$Trait2, function(s) { as.character(unique(filter(meta, sid ==s)$uniqValue)) })
rg$sex1  <- sapply(rg$Trait1, function(e) { filter(meta, sid==e)$sex} )
rg$sex2  <- sapply(rg$Trait2, function(e) { filter(meta, sid==e)$sex} )
rg$pair_sids <- sapply(1:nrow(rg), function(i) { paste0(c(rg$Trait1[i], rg$Trait2[i]), collapse=":") })


write.table(rg, "./real/outputs/formatted_rg_res.txt", sep="\t", row.names=F, quote=F)

 

