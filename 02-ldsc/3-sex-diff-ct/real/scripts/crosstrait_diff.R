library(data.table)
library(dplyr)
library(xtable)
library(stringr)


args <- commandArgs(T)

rg_file <- args[1]
powered_file <- args[2]
meta_file <- args[3]




# -----------
rg <- fread(rg_file)
meta <- fread(meta_file)
powered <- fread(powered_file, header=F)$V1


rg <- filter(rg, Trait1 %in% meta$sid & Trait2 %in% meta$sid) 
rg <-  filter(rg, Trait1 %in% powered & Trait2 %in% powered)


# cross trait
rg <- filter(rg, Trait1_name!=Trait2_name, sex1==sex2)


# format
rg$Trait1_name <- sapply(rg$Trait1_name, function(t) { str_split(t, 'requested|atlas|neales' ,)[[1]][1]})
rg$Trait1_name <-  sapply(rg$Trait1_name, function(t) { gsub("adjusted for BMI", "adjBMI", t, fixed =  T) })
rg$Trait1_name <- sapply(rg$Trait1_name, function(t) { substr(x=t, 1, nchar(t)-2 ) })
rg$Trait2_name <- sapply(rg$Trait2_name, function(t) { str_split(t, 'requested|atlas|neales|elena' ,)[[1]][1]})
rg$Trait2_name <-  sapply(rg$Trait2_name, function(t) { gsub("adjusted for BMI", "adjBMI", t, fixed =  T) })
rg$Trait2_name <- sapply(rg$Trait2_name, function(t) { substr(x=t, 1, nchar(t)-2 ) })
# alphabetically sorted Pair Name
rg$pair_name<- sapply(1:nrow(rg), function(i) { paste(sort( c(rg$Trait1_name[i], rg$Trait2_name[i])  ), collapse="---")   })

# FDR adj within sex
rg$PValue <- as.numeric(rg$PValue)
rg_f <- filter(rg, sex1=="female", sex2=="female" ) 
rg_f$P_adj <- p.adjust(rg_f$PValue, method="fdr")
rg_m <- filter(rg,  sex1=="male", sex2=="male")
rg_m$P_adj <- p.adjust(rg_m$PValue, method="fdr")

# one line male, female statistics
rg_mf_merge <- merge(rg_m, rg_f, by="pair_name", all=TRUE)
#
# save all unfiltered results > 3160 pairs in each sex
write.table(rg_f, "./real/outputs/f_crosstrait.txt", row.names=FALSE, quote=FALSE, sep="\t")
write.table(rg_m, "./real/outputs/m_crosstrait.txt", row.names=FALSE, quote=FALSE, sep="\t")
write.table(rg_mf_merge, "./real/outputs/merge_crosstrait.txt", row.names=FALSE, quote=FALSE, sep="\t")


# FDR-significant genetic correlations within sex
rg_f_sig <- filter(rg_f, P_adj< 0.05) 
rg_m_sig <- filter(rg_m, P_adj<0.05)

# FDR-significant genetic correlations in either sex --------------------------------------------------- 
# joint table m f 
rg_sig <- rbind(rg_f_sig, rg_m_sig) # 
write.table(rg_sig, "./real/outputs/rg_sig.txt", row.names=FALSE, quote=FALSE, sep="\t")
# one line male, female statistics filtered to FDR-significant genetic correlations in either sex
rg_sig_mf_merge <- filter(rg_mf_merge, P_adj.x<0.05 | P_adj.y<0.05) # 1965
write.table(rg_sig_mf_merge, "./real/outputs/merge_crosstrait_sig.txt", row.names=FALSE, quote=FALSE, sep="\t")


# FDR-significant genetic correlations in both sexes --------------------------------------------------- 
# joint table m f
rg_sig_shared <- filter(rg_sig, pair_name %in% intersect(rg_f_sig$pair_name, rg_m_sig$pair_name))
write.table(rg_sig_shared, "./real/outputs/rg_sig_shared.txt", row.names=FALSE, quote=FALSE, sep="\t")
# one line (merge)
rg_sig_mf_shared_merge <- filter(rg_mf_merge, P_adj.x<0.05 & P_adj.y<0.05)   # 1263
