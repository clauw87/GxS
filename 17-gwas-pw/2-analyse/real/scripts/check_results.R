args <- commandArgs(T)

library(data.table)
library(dplyr)
library(stringr)
library(xtable)

#   res_file <- "./real/outputs/restable.0.9.txt"

res_file <- args[1]
res_dir <- args[2]  # ../1-run/real/outputs

# --------------------------------------------------------------------
res <- fread(res_file)
colnames(res) <- c("pair", "loci", "single", "distinct")

meta_file <- "../../00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains_updated.txt"
meta <- fread(meta_file)

res$sid1 <- sapply(res$pair, function(p) { str_split(p, ":")[[1]][1] })
res$sid2 <- sapply(res$pair, function(p) { str_split(p, ":")[[1]][2] })
res$trait1 <- sapply(res$sid1, function(d) { filter(meta, sid==d)$trait_name_clean })
res$trait2 <- sapply(res$sid2, function(d) { filter(meta, sid==d)$trait_name_clean})
res <- filter(res, sid1 %in% meta$sid & sid2 %in% meta$sid)
res$sex <- sapply(res$sid1, function(d) { filter(meta, sid==d)$sex })


# res$sex2 <- sapply(res$sid2, function(d) { filter(meta, sid==d)$sex })
# trait name alphabetical order of trait names

#res$trait1 <- sapply(res$trait1 , function(t) { str_split(t, 'requested|atlas|neales')[[1]][1]})
#res$trait1<- sapply(res$trait1 , function(t) { gsub(pattern = "adjusted for BMI", replacement = "adjBMI", x = t) })
#res$trait1 <- sapply(res$trait1, function(t) { substr(x = t, start = 1, stop = nchar(t)-2)     })

#res$trait2 <- sapply(res$trait2 , function(t) { str_split(t, 'requested|atlas|neales')[[1]][1]})
#res$trait2<- sapply(res$trait2 , function(t) { gsub(pattern = "adjusted for BMI", replacement = "adjBMI", x = t) })
#res$trait2 <- sapply(res$trait2, function(t) { substr(x = t, start = 1, stop = nchar(t)-2)     })


res$trait_pair<-sapply(1:nrow(res),function(i){ paste(sort(c(res$trait1[i],res$trait2[i])), collapse=":")})


# Per trait pair, loci num diff males-females
trait_pairs <- unique(res$trait_pair)
per_pair <- data.frame(
                 trait_pair=trait_pairs, 
                 loci_males=sapply(trait_pairs, function(e) { sum(filter(res, trait_pair==e, sex=="male")$loci) }), 
                 loci_females=sapply(trait_pairs, function(e) { sum(filter(res, trait_pair==e, sex=="female")$loci) })
                  )

filter(per_pair, loci_males>0 & loci_females>0)$trait_pair

per_pair$loci_diff  <- abs(per_pair$loci_males - per_pair$loci_females)



#res <- filter(res, loci>0)
write.table(res, "./real/outputs/formatted_restable.txt", sep=" ", quote=F, row.names=F)
write.table(per_pair, "./real/outputs/per_pair.txt", sep=" ", quote=F, row.names=F)


res_tab <- res %>% filter(loci>0) %>% select(trait_pair, sex, loci, single, distinct) %>% arrange(desc(loci))
tex_tab<- print(xtable(res_tab), include.rownames=FALSE)
write(tex_tab, paste0("./real/outputs", "/", "pairs_with_pleios", ".tex") )




# pairs with  pleiotropic loci

unique(filter(res, loci>0)$trait_pair) 

res_f <- res %>% filter(loci>0, sex=="female")
res_m <- res %>% filter(loci>0, sex=="male")

both <- intersect(res_f$trait_pair, res_m$trait_pair)
# 205 trait_pairs
both_df <- filter(res, loci>0, trait_pair %in% both)


# sex-specific
sex_specific <- setdiff(unique(filter(res, loci>0)$trait_pair), both)
f_specific <- setdiff(res_f$trait_pair, both)
m_specific <- setdiff(res_m$trait_pair, both)


# BOTH SEXES
# both: they shared some same regions
res_dir <- "../1-run/real/outputs"
thr <- 0.9 
tab2 <- data.frame()
for (u in unique(both_df$trait_pair)) {
u_pairs <- c(filter(res, trait_pair==u, sex=="male")$pair, filter(res, trait_pair==u, sex=="female")$pair)
u_1 <- u_pairs[1]
u_2 <- u_pairs[2]
r_1 <- fread(paste0(res_dir, "/", u_1, ".cor.segbfs.gz"))
r_2 <- fread(paste0(res_dir, "/", u_2, ".cor.segbfs.gz"))
m_c <- length(r_1[PPA_4>thr,]$chunk)
f_c <- length(r_2[PPA_4>thr,]$chunk)
mf_c <- length(intersect(r_1[PPA_4>thr,]$chunk, r_2[PPA_4>thr,]$chunk))
tmp_tab2 <- data.frame(trait_pair=u, male=m_c, female=f_c, shared=mf_c)
tab2 <- rbind(tab2, tmp_tab2)
}

write.table(tab2, "./real/outputs/traits_with_pleio_in_both.ppa409.txt", sep="\t", quote=F, row.names=F)
tex_tab2 <- print(xtable(tab2), include.rownames=FALSE)
write(tex_tab2, paste0("./real/outputs", "/", "pairs_with_pleios_in_both.ppa409", ".tex") )






# one sex only
# for sex specific
rm(r_1); rm(r_2)
thr <- 0.9
tab3 <- data.frame()
for (u in unique(sex_specific)) {
u_pairs <- c(filter(res, trait_pair==u, sex=="male")$pair, filter(res, trait_pair==u, sex=="female")$pair)
u_1 <- u_pairs[1]
u_2 <- u_pairs[2]
r_1 <- fread(paste0(res_dir, "/", u_1, ".cor.segbfs.gz"))
r_2 <- fread(paste0(res_dir, "/", u_2, ".cor.segbfs.gz"))
m_c <- length(r_1[PPA_4>thr,]$chunk)
f_c <- length(r_2[PPA_4>thr,]$chunk)
mf_c <- length(intersect(r_1[PPA_4>thr,]$chunk, r_2[PPA_4>thr,]$chunk))
tmp_tab3 <- data.frame(trait_pair=u, male=m_c, female=f_c, shared=mf_c)
tab3 <- rbind(tab3, tmp_tab3)
}
write.table(tab3, "./real/outputs/pairs_with_sex-excl-pleios.pp409.txt", sep="\t", quote=F, row.names=F)
tab3$max <- ifelse(tab3$male >= tab3$female, tab3$male, tab3$female)
tab3 <- tab3 %>% filter(max>0) %>% arrange(desc(max)) %>% select(-max)
tex_tab3 <- print(xtable(tab3), include.rownames=FALSE)
write(tex_tab3, paste0("./real/outputs", "/", "pairs_with_sex-excl-pleios.pp409", ".tex") )


tab3_m <- tab3 %>% filter(male>0)
tab3_f <- tab3 %>% filter(female>0)
tex_tab3_m <- print(xtable(tab3_m), include.rownames=FALSE)
tex_tab3_f <- print(xtable(tab3_f), include.rownames=FALSE)
write(tex_tab3_m, paste0("./real/outputs", "/", "gwas-pw.pleio.mexcl.loci.pp409", ".tex") )
write(tex_tab3_f, paste0("./real/outputs", "/", "gwas-pw.pleio.fexcl.loci.pp409", ".tex") )





# join common and specific regions
tab2_tab3 <- rbind(tab2, tab3)
tab2_tab3$max <- ifelse(tab2_tab3$male >= tab2_tab3$female, tab2_tab3$male, tab2_tab3$female)
tab2_tab3$sexspecific <- tab2_tab3$male + tab2_tab3$female - tab2_tab3$shared
tab2_tab3$specifratio <-tab2_tab3$sexspecific/(tab2_tab3$sexspecific + tab2_tab3$shared)
tab2_tab3 <- tab2_tab3 %>% filter(max>0) %>% arrange(desc(specifratio), desc(max)) %>% select(-max, -sexspecific, -specifratio)
write.table(tab2_tab3, "./real/outputs/gwas-pw.pleio.loci.pp409.table", sep="\t", quote=F, row.names=F)
tex_tab2_tab3 <- print(xtable(tab2_tab3), include.rownames=FALSE)
write(tex_tab2_tab3, paste0("./real/outputs", "/", "gwas-pw.pleio.loci.ppa409", ".tex") )


tab2_tab3$trait_pair <- as.character( tab2_tab3$trait_pair)


#sapply(tab2_tab3$trait_pair, function(t) {     }  )
