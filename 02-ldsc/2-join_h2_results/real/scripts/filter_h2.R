#  2023 — LDSC is sensitive to the following criteria when calculating genetic correlation: • Heritability (H2) Z score is at least >1.5 (ideally >4).
# https://jcpres.com/storage/upload/pdfs/CPR-18209-ORIGINAL_ARTICLE-OZTORNACI.pdf

args <- commandArgs(T)



library(data.table)
library(dplyr)


h2_file <- args[1]
meta_file <- args[2]


#meta <- fread("/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/0-download/1-get_traitsinfo/gxs_sumstats.tsv")
#meta$uniqValue <- paste0(meta$Trait, "_", meta$PMID)
#meta <- fread("/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt")
#meta <- fread("/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/joined_metadata_domains.txt")
#meta$uniqValue <- paste0(meta$Trait, " ", meta$sid)

meta <- fread(meta_file)

#h2 <- fread("./real/outputs/h2.txt")
h2 <- fread(h2_file)

h2 <- filter(h2,Trait %in% meta$sid)


h2$Z_H2 <- h2$H2/h2$H2_SE
h2$P <- pnorm(abs(h2$Z_H2), lower.tail=F) # one tail

h2$FDR2sexes <- p.adjust(h2$P, method="fdr", n=nrow(h2)) # adjusted within sex
#h2$P_adj <- h2$P*(nrow(h2)/2) # Bonferroni 1 sex is more stringent

h2 <- filter(h2, FDR2sexes < 0.05)

h2$sex <- sapply(h2$Trait, function(e) { filter(meta, sid==e)$sex} )

#library(stringr)
#h2 <- filter(h2 , !(str_detect(string=Trait, pattern="em_")| str_detect(string=Trait, pattern="ef_")))	# 132: 66


meta$code1 <-  sapply(1:length(meta$sid), function(i) { strsplit(x=meta$pair[i], split=" ", fixed=TRUE)[[1]][1]})
meta$code2 <-  sapply(1:length(meta$sid), function(i) { strsplit(x=meta$pair[i], split=" ", fixed=TRUE)[[1]][2]})



h2$uniqValue <- sapply(h2$Trait, function(t) { unique(meta[ meta$sid==t,]$uniqValue) } )
h2$source <- sapply(h2$Trait, function(t) { unique(meta[ meta$sid==t,]$source) } )

# some duplicated trait name clean, bc elena and neales, both not included at the end in main analyses
h2$trait_name_clean <- sapply(h2$Trait, function(t) { unique(meta[ meta$sid==t,]$trait_name_clean)  } )


write.table(h2, "./real/outputs/h2_formatted.txt", sep="\t", quote=F, row.names=F, col.names=T)


h2_requested <- filter(h2, source!="neales" & source!="elena") 
write.table(h2_requested, "./real/outputs/h2_requested_formatted.txt", sep="\t", quote=F, row.names=F, col.names=T)




# Not to report, reporting Z>=2
h2_nom <- filter(h2, P<0.05)
table(h2_nom$sex) # 57 m 59 m
h2_nom_both <- filter(h2_nom, Trait %in% filter(meta, code1 %in% h2_nom$Trait & code2 %in% h2_nom$Trait)$sid)  #  114 
table(h2_nom_both$sex)
write.table(h2_nom_both$Trait, "./real/outputs/h2_nominal.txt", sep="\t", quote=F, row.names=F, col.names=F)



# Z2 
h2_Z2 <- filter(h2, Z_H2 >= 2) # 
h2_Z2_both <- filter(h2_Z2 , Trait %in% filter(meta, code1 %in% h2_Z2$Trait & code2 %in% h2_Z2$Trait)$sid)  # 114
write.table(h2_Z2_both, "./real/outputs/h2_powered_2_df.txt", sep="\t", quote=F, row.names=F, col.names=F)
write.table(h2_Z2_both$Trait, "./real/outputs/h2_powered_2.txt", sep="\t", quote=F, row.names=F, col.names=F)


# Z2 0.02
h2_Z2_2 <- filter(h2, Z_H2 >= 2 & H2>0.02)
h2_Z2_2_both <- filter(h2 , Trait %in% filter(meta, code1 %in% h2_Z2_2$Trait & code2 %in% h2_Z2_2$Trait)$sid)  # 114
write.table(h2_Z2_2_both$Trait, "./real/outputs/h2_powered_2_2.txt", sep="\t", quote=F, row.names=F, col.names=F)

# Z3
h2_Z3 <- filter(h2, Z_H2 >= 3)
h2_Z3_both <- filter(h2 , Trait %in% filter(meta, code1 %in% h2_Z3$Trait & code2 %in% h2_Z3$Trait)$sid)  # 138 out of 229 # 276 datasets.
write.table(h2_Z3_both$Trait, "./real/outputs/h2_powered_3.txt", sep="\t", quote=F, row.names=F, col.names=F)


h2_best <- filter(h2, Z_H2 >= 4, H2>=0.02) #
h2_best_both <- filter(h2, Trait %in% filter(meta, code1 %in% h2_best$Trait & code2 %in% h2_best$Trait)$sid) # 
write.table(h2_best_both$Trait, "./real/outputs/h2_powered_4_2.txt", sep="\t", quote=F, row.names=F, col.names=F)


h2_Z4 <- filter(h2 , Z_H2 >= 4) 
table(h2_Z4$sex)
h2_Z4_both <- filter(h2, Trait %in% filter(meta, code1 %in% h2_Z4$Trait & code2 %in% h2_Z4$Trait)$sid) 
table(h2_Z4_both$sex)
write.table(h2_Z4_both, "./real/outputs/h2_powered_4_df.txt",  sep="\t", quote=F, row.names=F, col.names=F)
write.table(h2_Z4_both$Trait, "./real/outputs/h2_powered_4.txt",  sep="\t", quote=F, row.names=F, col.names=F)



filter(h2_Z2_both, !(source %in% c("elena", "neales"))) %>% select(trait_name_clean) %>% unique # 51
filter(h2_Z4_both, !(source %in% c("elena", "neales"))) %>% select(trait_name_clean) %>% unique # 43



h2_Z2_both_noukbb <- filter(h2_Z2_both, !(source %in% c("elena", "neales"))) 
write.table(h2_Z2_both_noukbb$Trait, "./real/outputs/h2_powered_2_noukbb.txt",  sep="\t", quote=F, row.names=F, col.names=T)

h2_Z4_both_noukbb <- filter(h2_Z4_both, !(source %in% c("elena", "neales"))) 
write.table(h2_Z4_both_noukbb$Trait, "./real/outputs/h2_powered_4_noukbb.txt",  sep="\t", quote=F, row.names=F, col.names=T)

