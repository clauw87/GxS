# CT diff T test 
library(data.table)
library(dplyr)
library(xtable)
library(stringr)

args <- commandArgs(T)

rg_file <- args[1]
powered_file <- args[2]
meta_file <- args[3]

#  "../3-join_rg_results/real/outputs/formatted_rg_res.txt")
rg <- fread(rg_file)
meta <- fread(meta_file)
powered <- fread(powered_file, header=F)$V1


rg <- filter(rg, Trait1 %in% meta$sid & Trait2 %in% meta$sid) 
rg <-  filter(rg, Trait1 %in% powered & Trait2 %in% powered)


# cross trait
rg <- filter(rg, Trait1_name!=Trait2_name, sex1==sex2) # 6320 pairs: 3160 pairs per sex

# " NA"
rg$Trait1_name <- sapply(rg$Trait1_name, function(t) { str_split(t, 'requested|atlas|neales|elena' ,)[[1]][1]})
rg$Trait1_name <-  sapply(rg$Trait1_name, function(t) { gsub("adjusted for BMI", "adjBMI", t, fixed =  T) })
####rg$Trait1_name <- sapply(rg$Trait1_name, function(t) { gsub(" (", "", t, fixed =  T) })
rg$Trait1_name <- sapply(rg$Trait1_name, function(t) { substr(x=t, 1, nchar(t)-2 ) })
rg$Trait1_name <- sapply(rg$Trait1_name, function(t) { str_trim(string=t, side="right") } )

rg$Trait2_name <- sapply(rg$Trait2_name, function(t) { str_split(t, 'requested|atlas|neales|elena' ,)[[1]][1]})
rg$Trait2_name <-  sapply(rg$Trait2_name, function(t) { gsub("adjusted for BMI", "adjBMI", t, fixed =  T) })
####rg$Trait2_name <- sapply(rg$Trait2_name, function(t) { gsub(" (", "", t, fixed =  T) })
rg$Trait2_name <- sapply(rg$Trait2_name, function(t) { substr(x=t, 1, nchar(t)-2 ) })
rg$Trait2_name <- sapply(rg$Trait2_name, function(t) { str_trim(string=t, side="right") } )

# Alpabetically sorted Pair Names
rg$pair_name<- sapply(1:nrow(rg), function(i) { paste(sort( c(rg$Trait1_name[i], rg$Trait2_name[i])  ), collapse="---")   })


# FDR adjusted p-values for multiple comparisons  within sex
rg$PValue <- as.numeric(rg$PValue)
rg_f <- filter(rg, sex1=="female", sex2=="female" ) 
rg_f$P_adj <- p.adjust(rg_f$PValue, method="fdr")

filter(rg_f, PValue< 0.05) # 665 out of  1485  nominally
filter(rg_f, P_adj< 0.05) # 575 out of  1485  adj sig


rg_m <- filter(rg,  sex1=="male", sex2=="male")
rg_m$P_adj <- p.adjust(rg_m$PValue, method="fdr")

filter(rg_m, PValue< 0.05) # 583 out of	 1485 nominally sig in males
filter(rg_m, P_adj< 0.05) # 482  out of  1485 adj


# merge into one line
rg_mf_merge <- merge(rg_m, rg_f, by="pair_name", all=TRUE) # 3160 , 

# all results unfiltered> 3160 pairs in each sex
write.table(rg_f, "./real/outputs/f_crosstrait.txt", row.names=FALSE, quote=FALSE, sep="\t")
write.table(rg_m, "./real/outputs/m_crosstrait.txt", row.names=FALSE, quote=FALSE, sep="\t")
write.table(rg_mf_merge, "./real/outputs/merge_crosstrait.txt", row.names=FALSE, quote=FALSE, sep="\t")


# fdr sig correlations
rg_f_sig <- filter(rg_f, P_adj< 0.05) # 1755
rg_m_sig <- filter(rg_m, P_adj<0.05) 



# FDR sig GC in EITHER SEX ------------------------
# filter to sig trait pairs in either sex
rg_sig <- rbind(rg_f_sig, rg_m_sig) # 3228 pairs 
length(unique(rg_sig$pair_name)) # 1965 unique pair names from 1755 male, 1473 female, partially overlaping (shared ones 1263 intersect)
write.table(rg_sig, "./real/outputs/rg_sig.txt", row.names=FALSE, quote=FALSE, sep="\t")
# filter to sig in either merge one line 
rg_sig_mf_merge <- filter(rg_mf_merge, P_adj.x<0.05 | P_adj.y<0.05) # 1965
write.table(rg_sig_mf_merge, "./real/outputs/merge_crosstrait_sig.txt", row.names=FALSE, quote=FALSE, sep="\t")


# FDR sig GC in BOTH SEXES ------------------------
# sig trait pairs in both sexes
#rg_sig_mf_pair_names <- intersect(rg_f_sig$pair_name, rg_m_sig$pair_name)
#length(rg_sig_mf_pair_names) # 395 .. 1263

#rg_sig_mf_shared <- filter(rg_sig_mf, pair_name %in% rg_sig_mf_pair_names)
# joint table m f
rg_sig_shared <- filter(rg_sig, pair_name %in% intersect(rg_f_sig$pair_name, rg_m_sig$pair_name)) # 2526 pairs lines rbound, 1263 unique pair_names
write.table(rg_sig_shared, "./real/outputs/rg_sig_shared.txt", row.names=FALSE, quote=FALSE, sep="\t")
# one line (merge)
rg_sig_mf_merge_shared <- filter(rg_mf_merge, P_adj.x<0.05 & P_adj.y<0.05)   # 1263 pairs lines, 1263 unique
write.table(rg_sig_mf_merge_shared, "./real/outputs/merge_crosstrait_sig_shared.txt", row.names=FALSE, quote=FALSE, sep="\t")




# -------------


# CHEC SIGNIFICANT CORRELATIONS IN BOTH
#rg_sig_mf_mer <- merge(rg_m_sig, rg_f_sig, by="pair_name") %>% filter(pair_name %in% rg_sig_mf_shared$pair_name) 
#rg_sig_mf_mer <- rg_sig_mf_mer %>% select("pair_name", "GC.x", "GC_SE.x", "GC.y",  "GC_SE.y", "P_adj.x", "P_adj.y")
#dim(rg_sig_mf_mer) # 395 .. 1263
#write.table(rg_sig_mf_mer, "./real/outputs/mf_shared_sig.txt", row.names=FALSE, quote=FALSE, sep="\t")

# SIGNIFICANT IN EITHER SEX
#rg_sig_mf_either <- merge(rg_m_sig, rg_f_sig, by="pair_name", all=TRUE) %>% filter(pair_name %in% unique(rg_sig_mf$pair_name))
#rg_sig_mf_either <- rg_sig_mf_either  %>% select("pair_name", "GC.x", "GC_SE.x", "GC.y",  "GC_SE.y", "P_adj.x", "P_adj.y")
#dim(rg_sig_mf_either) # 1965
#write.table(rg_sig_mf_either, "./real/outputs/mf_either_sig.txt", row.names=FALSE, quote=FALSE, sep="\t")


# -----------------------------------------------------------------------------------------------------------------------
# Sex differences in the rg estimate
# among the 395 (1263) with sig rg in both sexes
#rg_sig_mf_mer <- fread("./real/outputs/mf_shared_sig.txt")
# rg_sig_mf_mer  <- fread("")
#rg_sig_mf_mer$stat <- (rg_sig_mf_mer$GC.x - rg_sig_mf_mer$GC.y)/sqrt(rg_sig_mf_mer$GC_SE.x^2 + rg_sig_mf_mer$GC_SE.y^2)
#table(rg_sig_mf_mer$stat>0) # FASLE  780   TRUE 483 
#rg_sig_mf_mer$p_diff <- 2*pnorm(q=abs(rg_sig_mf_mer$stat), lower.tail=FALSE)
#rg_sig_mf_mer$p_diff_adj <- p.adjust(rg_sig_mf_mer$p_diff, method="fdr")
#filter(rg_sig_mf_mer, p_diff<0.05) # 90 nominal sig sex difference 
#filter(rg_sig_mf_mer, p_diff_adj<0.05) # 37 FDR sig sex difference among shared sign correlated ones

# over all 1057 (1965) with rg significant in either sex:  one
# overall
rg_mdf <- rg_sig_mf_merge
rg_mdf$stat <- (rg_mdf$GC.x - rg_mdf$GC.y)/sqrt(rg_mdf$GC_SE.x^2 + rg_mdf$GC_SE.y^2)
rg_mdf$p_diff <- 2*pnorm(q=abs(rg_mdf$stat), lower.tail=FALSE)
rg_mdf$p_diff_adj <- p.adjust(rg_mdf$p_diff, method="fdr")
# TABULATE
rg_mf_diff <- rg_mdf
rg_mf_diff$rg_m <- paste0(rg_mf_diff$GC.x, " (", rg_mf_diff$GC_SE.x, ")")
rg_mf_diff$rg_f <- paste0(rg_mf_diff$GC.y, " (", rg_mf_diff$GC_SE.y, ")")
#rg_mf_diff <- rg_mf_diff %>% select("pair_name", "rg_m", "rg_f" , "p_diff", "p_diff_adj")
rg_mf_diff <- rg_mf_diff %>% arrange(p_diff_adj)
write.table(rg_mf_diff, "./real/outputs/mf_diff.txt", row.names=FALSE, quote=FALSE, sep="\t")
# Sex diff Nominal P < 0.05
rg_mf_diff_nominal <- filter(rg_mf_diff,  p_diff<0.05)
write.table(rg_mf_diff_nominal, "./real/outputs/mf_diff_nominal.txt", row.names=FALSE, quote=FALSE, sep="\t")
#unique(c(rg_mf_diff_nominal$Trait1_name.x, rg_mf_diff_nominal$Trait2_name.x)) # involving 64 traits - 37 with nonukbb
# Sex diff FDR < 0.05
rg_mf_diff_fdr <- filter(rg_mf_diff,  p_diff_adj<0.05)
write.table(rg_mf_diff_fdr, "./real/outputs/mf_diff_fdr.txt", row.names=FALSE, quote=FALSE, sep="\t")
unique(c(rg_mf_diff_fdr$Trait1_name.x, rg_mf_diff_fdr$Trait2_name.x)) # involving 48 traits - 33 noukbb
# nominal only
rg_mf_diff_nominal_only <- filter(rg_mf_diff_nominal, p_diff_adj>0.05) # 261 pairs - 61 non ukbb


# TEX FDR
tab <-  rg_mf_diff_fdr %>% select("pair_name", "rg_m", "rg_f" , "p_diff", "p_diff_adj")
tab$p_diff <- sapply(tab$p_diff, function(e) {format(e, scientific=T)})
tab$p_diff_adj <- sapply(tab$p_diff_adj, function(e) {format(e, scientific=T)})
colnames(tab) <- c("Pair", "rg(se) males", "rg(se) females", "P diff", "P diff adj")
summary(tab$`P diff adj`)
# latex table
tex_table <- print(xtable(tab ), include.rownames=FALSE)
write(tex_table, paste0("./real/outputs", "/", "mf_diff_fdr.tex"))
# TEX Nominal
tab <-  rg_mf_diff_nominal %>% select("pair_name", "rg_m", "rg_f" , "p_diff", "p_diff_adj")
tab$p_diff <- sapply(tab$p_diff, function(e) {format(e, scientific=T)})
tab$p_diff_adj <- sapply(tab$p_diff_adj, function(e) {format(e, scientific=T)})                           
colnames(tab) <- c("Pair", "rg(se) males", "rg(se) females", "P diff", "P diff adj")
summary(tab$`P diff adj`)
# latex table
tex_table <- print(xtable(tab ), include.rownames=FALSE)
write(tex_table, paste0("./real/outputs", "/", "mf_diff_nominal.tex"))




# SEX EXCLUSIVE AND "SEX-SPECIFIC" --------


# MALE EXCLUSIVE
#m_exc_pairs <- setdiff(rg_m_sig$pair_name, rg_sig_mf_pair_names) #  87 pairs 
#m_exc_pairs <- filter(rg_mf, P_adj.x <0.05 &  P_adj.y>0.05)$pair_name # 87
# how many in FDR sex diff
#intersect(sex_diff_fdr$pair_name, m_exc_pairs) # 15
# More stringent
# rg_mdf
m_t_exc_pairs <- filter(rg_mdf, P_adj.x <0.05 &  P_adj.y>0.3)$pair_name # 41/87 - 30 no ukbb
m_t_exc <- filter(rg_mdf, pair_name %in% m_t_exc_pairs)
m_t_exc <- m_t_exc %>% arrange(p_diff_adj)
write.table(m_t_exc, "./real/outputs/m_specific_sig.txt", row.names=FALSE, quote=FALSE, sep="\t")
# tex table
tab <- m_t_exc
tab$rg_m <- paste0(tab$GC.x, " (", tab$GC_SE.x, ")")
tab$rg_f <- paste0(tab$GC.y, " (", tab$GC_SE.y, ")")
tab <- tab %>% select("pair_name",  "rg_m", "rg_f" , "P_adj.x" , "P_adj.y"  )
tab <- tab  %>% arrange(P_adj.x)
tab %>% head()
colnames(tab) <- c("Pair", "rg(se) males", "rg(se) females", "P adj males", "P adj females")
tex_table <- print(xtable(tab), include.rownames=FALSE)
write(tex_table, paste0("./real/outputs", "/", "m_specific_sig.tex"))





# FEMALE EXCLUSIVE
#f_exc_pairs <- setdiff(rg_f_sig$pair_name, rg_sig_mf_pair_names) # 180
#f_exc_pairs <-  filter(rg_mdf, P_adj.y <0.05 & P_adj.x>0.05)$pair_name # 180
# how many in FDR sex diff
#intersect(sex_diff_fdr$pair_name, f_exc_pairs) # 16

f_t_exc_pairs <- filter(rg_mdf, P_adj.y <0.05 & P_adj.x>0.3)$pair_name # 95
f_t_exc <- filter(rg_mdf, pair_name %in% f_t_exc_pairs)

f_t_exc <- f_t_exc  %>% arrange(P_adj.y)
write.table(f_t_exc, "./real/outputs/f_specific_sig.txt", row.names=FALSE, quote=FALSE, sep="\t")

tab <- f_t_exc
tab$rg_m <- paste0(tab$GC.x, " (", tab$GC_SE.x, ")")
tab$rg_f <- paste0(tab$GC.y, " (", tab$GC_SE.y, ")")
tab <- tab %>% select("pair_name",  "rg_m", "rg_f" , "P_adj.x" , "P_adj.y"  )
tab <- tab  %>% arrange(P_adj.y)
tab %>% head()
colnames(tab) <- c("Pair", "rg(se) males", "rg(se) females", "P adj males", "P adj females")
tex_table <- print(xtable(tab), include.rownames=FALSE)
write(tex_table, paste0("./real/outputs", "/", "f_specific_sig.tex"))


# SEX DIFF AND SEX-SPECIFIC
 
rg_mdf %>% filter(p_diff_adj<0.05, pair_name %in% f_t_exc_pairs) # 10
rg_mdf %>% filter(p_diff_adj<0.05, pair_name %in% m_t_exc_pairs) # 5


sex_diff_non_specific <- rg_mdf %>% filter(p_diff_adj<0.05, !(pair_name %in% c(f_t_exc_pairs, m_t_exc_pairs)))
tab <- sex_diff_non_specific 
tab$rg_m <- paste0(tab$GC.x, " (", tab$GC_SE.x, ")")
tab$rg_f <- paste0(tab$GC.y, " (", tab$GC_SE.y, ")")
tab <- tab %>% select("pair_name",  "rg_m", "rg_f" , "P_adj.x" , "P_adj.y"  )
tab <- tab  %>% arrange(P_adj.y)
colnames(tab) <- c("Pair", "rg(se) males", "rg(se) females", "P adj males", "P adj females")
tex_table <- print(xtable(tab), include.rownames=FALSE)
write(tex_table, paste0("./real/outputs", "/", "nonspec_diff_sig.tex"))



#source("real/scripts/heatmap.rg.intrasex.R")
