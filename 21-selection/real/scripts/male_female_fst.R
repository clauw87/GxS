library(data.table)
library(dplyr)

args <- commandArgs(T)

#chr <- 1

#chr <- args[1]


#freq_strat <- fread(paste0("chr", chr, ".EUR.sexfreq.frq.strat"))

freq_strat <- fread("allchr.EUR.sexfreq.frq.strat")

freq_wide <- freq_strat %>%
  select(CHR, SNP, A1, CLST, MAF) %>%
  tidyr::pivot_wider(names_from = CLST, values_from = MAF) 
# %>%  filter(!is.na(MALE) & !is.na(FEMALE))


freq_wide <- freq_wide %>%
  mutate(
    p_bar = (MALE + FEMALE) / 2,
    FST = ((MALE - FEMALE)^2) / (4 * p_bar * (1 - p_bar))
  )



# Optional: filter for finite results only
#freq_wide <- freq_wide %>%
#  filter(is.finite(FST))

freq_wide$BP <- sapply(freq_wide$SNP, function(e)  { strsplit(x=e, split=":", fixed=T)[[1]][2]} )

freq_wide$id <- sapply(1:nrow(freq_wide), function(i) { paste0(freq_wide$CHR[i],":", freq_wide$BP[i], ":", freq_wide$A1[i])  })

# Preview top hits
head(freq_wide[order(-freq_wide$FST), ], 10)


write.table(freq_wide, "./real/inputs/mf_fst.tsv", sep="\t", quote=F, row.names=F)
