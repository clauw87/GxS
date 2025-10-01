library(data.table)
library(dplyr)
library(stringr)
library(xtable)


args <- commandArgs(T)


h2_file <- args[1]
powered_file <- args[2]
outputs_dir <- args[3]

sca <- "liab"

h2 <- fread(h2_file)
powered_ids <- fread(powered_file, header=T)$sid
h2 <- filter(h2, sid %in% powered_ids)


traits <- unique(h2$uniqValue)

H2_col <- ifelse(sca=="obs", H2, "H2L")
H2_SE_col <- ifelse(sca=="obs", H2_SE, "H2L_SE")
traits_name <- sapply(traits, function(u) { unique( h2[h2$uniqValue==u,]$trait_clean)})

f_est <- sapply(traits, function(u) { h2[h2$uniqValue==u & h2$sex=="female", ][["H2_col"]] })
f_est_se <- sapply(traits, function(u) { h2[h2$uniqValue==u & h2$sex=="female", ][["H2_SE_col"]] })
f_p <- sapply(traits, function(u) { h2[h2$uniqValue==u & h2$sex=="female", ][["H2L_P"]] })
f_z <- f_est/f_est_se
m_est <- sapply(traits, function(u) { h2[h2$uniqValue==u & h2$sex=="male", ][[H2_col]] })
m_est_se <- sapply(traits, function(u) { h2[h2$uniqValue==u & h2$sex=="male", ][[H2_SE_col]] })
m_p <- sapply(traits, function(u) { h2[h2$uniqValue==u & h2$sex=="male", ][["H2L_P"]] })
m_z <- m_est/m_est_se                   

compare  <- data.frame("trait"=traits, "trait_name"=traits_name, "m_est"=m_est, "m_est_se"=m_est_se, "m_z"=m_z, "m_p"=m_p, "f_est"=f_est, "f_est_se"=f_est_se,"f_z"=f_z, "f_p"=f_p)
compare$stat <- (compare$m_est - compare$f_est)/sqrt(compare$m_est_se^2 + compare$f_est_se^2)
compare$stat_abs <- abs(compare$stat)
compare$stat_sign <- as.integer(sign(compare$stat))  # positive male>male
compare$p_diff <- round(2*pnorm(q=abs(compare$stat), lower.tail=FALSE),2)
compare$p_diff_adj <- round(p.adjust(compare$p, method="fdr", n=length(compare$p_diff)),2)
compare$f_est <- round( compare$f_est ,2 )
compare$f_est_se <- round(  compare$f_est_se,2 )
compare$f_z <- round(compare$f_z, 2)
compare$m_est <- round( compare$m_est ,2 )
compare$m_est_se <-round( m_est_se ,2 )
compare$m_z <- round(compare$m_z, 2)
compare$stat  <- round(compare$stat,2)
compare$mf_pair <- sapply(compare$trait, function(t) { unique(meta[meta$uniqValue==t,]$pair_m_f) })
compare$m_sid <- sapply(compare$mf_pair, function(e) { strsplit(e, " ")[[1]][1]})
compare$f_sid <- sapply(compare$mf_pair, function(e) { strsplit(e, " ")[[1]][2]})


# Format cleaner Trait names
compare$TRAIT1_C <- sapply(compare$trait_name, function(t) { str_split(t, "requested|atlas|neales" )[[1]][1]  } )
compare$TRAIT1_C <- sapply(compare$TRAIT1_C, function(t) { gsub(pattern="adjusted for BMI", replacement="adjBMI", x=t) })


compare <- compare %>% arrange(desc(stat_abs),p_diff_adj)
write.table(compare, paste0("./real/outputs/compare_h2_", sca, "_scale.txt"), row.names=FALSE, quote=FALSE, sep="\t")


# Latex table - nominally significative results
compare$m <- paste0(compare$m_est, "(", compare$m_est_se , ")")
compare$f <- paste0(compare$f_est, "(", compare$f_est_se , ")")
compare_ <- compare %>% select(TRAIT1_C, m, f, stat, stat_sign, p_diff, p_diff_adj)
nom_sig <- filter(compare_, p_diff <0.05)
colnames(nom_sig) <-  c("Trait", "h2m(se)", "h2f(se)", "stat", "sign", "p diff", "p diff FDR")
tex_table <- print(xtable(nom_sig), include.rownames=FALSE)
write(tex_table, paste0(outputs_dir, "/", "compare_h2_",  sca, "_scale.tex") )



