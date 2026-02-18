library(data.table)
library(dplyr)
library(xtable)
library(stringr)


args <- commandArgs(T)
rg_file <- args[1]
meta_file <- args[2]
remove_ukbb <- toupper(args[3])


rg <- fread(rg_file)
meta <- fread(meta_file)

#rg <- fread("../3-join_rg_results/real/outputs/formatted_rg_res.txt")
#meta <- fread("/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt")
######meta$uniqValue <- paste0(meta$Trait, " ", meta$sid)

# meta
rg <- filter(rg, Trait1 %in% meta$sid & Trait2 %in% meta$sid)

# intra trait 
rg_intratrait <- filter(rg, Trait1_name==Trait2_name, sex1!=sex2)

# remove elenas for this analysis as it is published
if (remove_ukbb) {
elena_sids <- unique(filter(meta, source %in% c("elena", "neales"))$sid)
rg_intratrait <- filter(rg_intratrait, !(Trait1 %in% elena_sids |  Trait2 %in% elena_sids)) 
rg_intratrait$Trait1_name %>% unique %>% length # 57
}

# Calculate rg and FDR adjust for the multiple comparisons done
rg_intratrait$est <- sapply(rg_intratrait$Trait1, function(t) { rg_intratrait[rg_intratrait$Trait1==t, ]$GC })
rg_intratrait$est_se <- sapply(rg_intratrait$Trait1, function(t) { rg_intratrait[rg_intratrait$Trait1==t, ]$GC_SE })
# compare rg with 1
rg_intratrait$stat <- abs((rg_intratrait$est - 1)/rg_intratrait$est_se)
rg_intratrait$rg1_p <- pnorm(q=rg_intratrait$stat, lower.tail=FALSE)   # one tail for lower than 1

rg_intratrait$rg1_p_adj <- p.adjust(rg_intratrait$rg1_p, method="fdr", n=length(rg_intratrait$rg1_p))



#filter(rg_intratrait, Trait1_name=="Glycine level  (atlas) 31070104") # ns diff 0.8559 vs 1 nominal p 0.2037897 
#filter(rg_intratrait, est<1,  rg1_p<0.05) # 33
#rg_intratrait_fdr <- filter(rg_intratrait, est<1, rg1_p_adj<0.05) # 29
#filter(rg_intratrait, est<1,  rg1_p_adj<0.05) # 25


rg_intratrait <- rg_intratrait %>% arrange(est)

write.table(rg_intratrait, "./real/outputs/rg_intratrait.txt", sep="\t", quote=F, row.names=F)

#write.table(rg_intratrait_fdr, "./real/outputs/rg_intratrait_fdr.txt", sep="\t", quote=F, row.names=F)


# for tex table

rg_intratrait$rg_se <- paste0(rg_intratrait$est, " (", rg_intratrait$est_se, ")")
rg_intratrait$TRAIT1_C <- sapply(rg_intratrait$Trait1_name, function(t) { str_split(t, "requested|atlas|neales|elena" )[[1]][1]  } )
rg_intratrait$TRAIT1_C <- sapply(rg_intratrait$TRAIT1_C, function(t) {  substr(t, 1, nchar(t) -2)   }) # removes opening parenthesis and space
rg_intratrait$TRAIT1_C <- sapply(rg_intratrait$TRAIT1_C, function(t) { gsub(pattern="adjusted for BMI", replacement="adjBMI", x=t) })
#res$TRAIT2_C <-sapply(res$TRAIT2_C, function(t) { gsub(pattern="adjusted for BMI", replacement="adjBMI", x=t) })
rg_intratrait$PAIR <-  sapply(1:nrow(rg_intratrait), function(i) { paste(sort( c(rg_intratrait$TRAIT1_C[i], rg_intratrait$TRAIT1_C[i])  ), collapse=" --- ")   })
#rg_intratrait <- rg_intratrait %>% select("Trait1_name", "rg_se", "rg1_p_adj")

rg_intratrait_nominal <- filter(rg_intratrait, est<1,  rg1_p<0.05) # 38

rg_intratrait_fdr <- filter(rg_intratrait, est<1, rg1_p_adj<0.05) # 29


write.table(rg_intratrait_nominal, "./real/outputs/rg_intratrait_nominal.txt", sep="\t", quote=F, row.names=F)
write.table(rg_intratrait_fdr, "./real/outputs/rg_intratrait_fdr.txt", sep="\t", quote=F, row.names=F)




# TEX TABLES
rg_intratrait_nominal <-  rg_intratrait_nominal %>% arrange(est)
rg_intratrait_nominal <- rg_intratrait_nominal %>% select("TRAIT1_C", "rg_se", "rg1_p", "rg1_p_adj")
rg_intratrait_nominal$rg1_p <- sapply(rg_intratrait_nominal$rg1_p, function(e) { format(e, scientific=TRUE) })
rg_intratrait_nominal$rg1_p_adj <- sapply(rg_intratrait_nominal$rg1_p_adj, function(e) { format(e, scientific=TRUE) })

colnames(rg_intratrait_nominal) <- c("Trait", "rg(se)", "p diff 1", "p diff 1 FDR")

tex_table <- print(xtable(rg_intratrait_nominal), include.rownames=FALSE)
write(tex_table, "./real/outputs/rg_1_nominal.tex")

#rg_intratrait_fdr <- filter(rg_intratrait, est<1, rg1_p_adj<0.05) # 29
rg_intratrait_fdr <- rg_intratrait_fdr %>% arrange(est)
rg_intratrait_fdr$rg_se <- paste0(rg_intratrait_fdr$est, " (", rg_intratrait_fdr$est_se, ")")
rg_intratrait_fdr <- rg_intratrait_fdr %>% select("TRAIT1_C", "rg_se", "rg1_p",  "rg1_p_adj")
rg_intratrait_fdr$rg1_p <- sapply(rg_intratrait_fdr$rg1_p, function(e) { format(e, scientific=TRUE) })
rg_intratrait_fdr$rg1_p_adj <- sapply(rg_intratrait_fdr$rg1_p_adj, function(e) { format(e, scientific=TRUE) })


colnames(rg_intratrait_fdr) <- c("Trait", "rg(se)", "p diff 1", "p diff 1 FDR")
tex_table <- print(xtable(rg_intratrait_fdr), include.rownames=FALSE)
write(tex_table, "./real/outputs/rg_1_fdr.tex")




