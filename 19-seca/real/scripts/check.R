library(data.table)
library(dplyr)


meta <- fread("../00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains_updated.txt")

dir1 <- fread("real/outputs_dir1/all.primary.concordant.effects")
dir2 <- fread("real/outputs_dir2/all.primary.concordant.effects")

dir1$CODE1 <- sapply(dir1$CODE, function(e) { strsplit(e, ":")[[1]][1]  })
dir1$CODE2 <- sapply(dir1$CODE, function(e) { strsplit(e, ":")[[1]][2]  })
dir1$TRAIT1 <-	sapply(dir1$CODE1,  function(e) { filter(meta, sid==e)$trait_name_clean })
dir1$TRAIT2 <-  sapply(dir1$CODE2,  function(e) { filter(meta, sid==e)$trait_name_clean })
dir1$sex <-  sapply(dir1$CODE1,  function(e) { filter(meta, sid==e)$sex })
dir1$trait_pair <-	sapply(1:nrow(dir1),  function(i) {  paste(sort(c(dir1$TRAIT1[i],dir1$TRAIT2[i])), collapse=":")   })

dir1$DOMAIN1 <- sapply(dir1$CODE1,  function(e) { filter(meta, sid==e)$TYPE })
dir1$DOMAIN2 <-	sapply(dir1$CODE2,  function(e) { filter(meta, sid==e)$TYPE })
dir1$domain_pair <- sapply(1:nrow(dir1), function(i) { paste(sort(c(dir1$DOMAIN1[i],dir1$DOMAIN2[i])), collapse=":") })


dir2$CODE1 <- sapply(dir2$CODE, function(e) { strsplit(e, ":")[[1]][1]  })
dir2$CODE2 <- sapply(dir2$CODE, function(e) { strsplit(e, ":")[[1]][2]  })
dir2$TRAIT1 <-  sapply(dir2$CODE1,  function(e) { filter(meta, sid==e)$trait_name_clean })
dir2$TRAIT2 <-  sapply(dir2$CODE2,  function(e) { filter(meta, sid==e)$trait_name_clean })
dir2$sex <-  sapply(dir2$CODE1,  function(e) { filter(meta, sid==e)$sex })
dir2$trait_pair <- sapply(1:nrow(dir2),  function(i) {  paste(sort(c(dir2$TRAIT1[i],dir2$TRAIT2[i])), collapse=":")   })


dir2$DOMAIN1 <-	sapply(dir2$CODE1,  function(e) { filter(meta, sid==e)$TYPE })
dir2$DOMAIN2 <- sapply(dir2$CODE2,  function(e) { filter(meta, sid==e)$TYPE })
dir2$domain_pair <- sapply(1:nrow(dir2), function(i) { paste(sort(c(dir2$DOMAIN1[i],dir2$DOMAIN2[i])), collapse=":") })


# trait pairs with significant results in either direction per sex
## males
male_pairs <- c(filter(dir1, sex=="male", NOM_CON_SNPS_EMP_P<0.05)$trait_pair,
                  filter(dir2, sex=="male", NOM_CON_SNPS_EMP_P<0.05)$trait_pair)
female_pairs <- c(filter(dir1, sex=="female", NOM_CON_SNPS_EMP_P<0.05)$trait_pair,
                  filter(dir2, sex=="female", NOM_CON_SNPS_EMP_P<0.05)$trait_pair)

common <- intersect(male_pairs, female_pairs) # 366 pairs are significantly concordant in both


male_sp <- setdiff(male_pairs, female_pairs) # 102 pairs are significantly concordant in males only
female_sp <- setdiff(female_pairs, male_pairs) # 125	pairs are significantly	concordant in males only


write.table(male_sp, "./real/outputs/male_only_sig_concordance.txt", sep="\t", quote=F, row.names=F)
write.table(female_sp, "./real/outputs/female_only_sig_concordance.txt", sep="\t", quote=F, row.names=F)

