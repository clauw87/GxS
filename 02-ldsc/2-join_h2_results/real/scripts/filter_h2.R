#  2023 — LDSC is sensitive to the following criteria when calculating genetic correlation: • Heritability (H2) Z score is at least >1.5 (ideally >4).
# https://jcpres.com/storage/upload/pdfs/CPR-18209-ORIGINAL_ARTICLE-OZTORNACI.pdf

args <- commandArgs(T)



library(data.table)
library(dplyr)


h2_file <- args[1]
meta_file <- args[2]

meta <- fread(meta_file)


h2 <- fread(h2_file)
h2 <- filter(h2,Trait %in% meta$sid)


h2$Z_H2 <- h2$H2/h2$H2_SE
h2$P <- pnorm(abs(h2$Z_H2), lower.tail=F) # one tail
h2$FDR2sexes <- p.adjust(h2$P, method="fdr", n=nrow(h2)) # adjusted within sex
h2 <- filter(h2, FDR2sexes < 0.05)
h2$sex <- sapply(h2$Trait, function(e) { filter(meta, sid==e)$sex} )

meta$code1 <-  sapply(1:length(meta$sid), function(i) { strsplit(x=meta$pair[i], split=" ", fixed=TRUE)[[1]][1]})
meta$code2 <-  sapply(1:length(meta$sid), function(i) { strsplit(x=meta$pair[i], split=" ", fixed=TRUE)[[1]][2]})

h2$uniqValue <- sapply(h2$Trait, function(t) { unique(meta[ meta$sid==t,]$uniqValue) } )
h2$source <- sapply(h2$Trait, function(t) { unique(meta[ meta$sid==t,]$source) } )

h2$trait_name_clean <- sapply(h2$Trait, function(t) { unique(meta[ meta$sid==t,]$trait_name_clean)  } )
write.table(h2, "./real/outputs/h2_formatted.txt", sep="\t", quote=F, row.names=F, col.names=T)


# P < 0.05 
h2_nom <- filter(h2, P<0.05)
table(h2_nom$sex) # 57 m 59 m
h2_nom_both <- filter(h2_nom, Trait %in% filter(meta, code1 %in% h2_nom$Trait & code2 %in% h2_nom$Trait)$sid)  #  114 
table(h2_nom_both$sex)
write.table(h2_nom_both$Trait, "./real/outputs/h2_nominal.txt", sep="\t", quote=F, row.names=F, col.names=F)


# Z >= 2 
h2_Z2 <- filter(h2, Z_H2 >= 2) # 
h2_Z2_both <- filter(h2_Z2 , Trait %in% filter(meta, code1 %in% h2_Z2$Trait & code2 %in% h2_Z2$Trait)$sid)  # 114
write.table(h2_Z2_both, "./real/outputs/h2_powered_2_df.txt", sep="\t", quote=F, row.names=F, col.names=F)
write.table(h2_Z2_both$Trait, "./real/outputs/h2_powered_2.txt", sep="\t", quote=F, row.names=F, col.names=F)


# Z>= 2 and h2 0.02
h2_Z2_2 <- filter(h2, Z_H2 >= 2 & H2>0.02)

h2_Z2_2_both <- filter(h2 , Trait %in% filter(meta, code1 %in% h2_Z2_2$Trait & code2 %in% h2_Z2_2$Trait)$sid)  # 114
write.table(h2_Z2_2_both$Trait, "./real/outputs/h2_powered_2_2.txt", sep="\t", quote=F, row.names=F, col.names=F)


# Z>=4
h2_Z4 <- filter(h2 , Z_H2 >= 4) 
table(h2_Z4$sex)

# both sexes
h2_Z4_both <- filter(h2, Trait %in% filter(meta, code1 %in% h2_Z4$Trait & code2 %in% h2_Z4$Trait)$sid) 
table(h2_Z4_both$sex)
write.table(h2_Z4_both, "./real/outputs/h2_powered_4_df.txt",  sep="\t", quote=F, row.names=F, col.names=F)
write.table(h2_Z4_both$Trait, "./real/outputs/h2_powered_4.txt",  sep="\t", quote=F, row.names=F, col.names=F)

