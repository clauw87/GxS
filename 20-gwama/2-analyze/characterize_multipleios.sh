library(dplyr)
library(data.table)


repeated <- fread("/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/20-gwama/2-analyze/real/outputs/pooled.repeated.sbsnps")

repeated$count_traits <- sapply(repeated$SNP, function(s) { unique(filter(repeated, SNP==s)$CODE)})

# Many sex differential effect because sex-specific effect


# Opposite effect sex differential
# consider sign when Zs > 1

# Filter by a reasnable Z in both sexes
repeated <- filter(repeated, abs(Zf) > 3 &  abs(Zm) >3) # 1894 unique SNPs
# or ? filter later 

# Sex antagonistic
repeated$has_sa <- sapply(repeated$SNP, function(s) {  (any(filter(repeated, SNP==s)$Zm>0) &  any(filter(repeated, SNP==s)$Zf<0)) |  any(filter(repeated, SNP==s)$Zm<0) &  any(filter(repeated, SNP==s)$Zf>0)   })
repeated$allsexsp <- sapply(repeated$SNP, function(s) { 
 (all(abs(filter(repeated, SNP==s)$Zm)>3) & all(abs(filter(repeated, SNP==s)$Zf)<1)) | ( all(abs(filter(repeated, SNP==s)$Zf)>3) & all(abs(filter(repeated, SNP==s)$Zm)<1 )) })

# Considerable opposite pleiotropies, the SNPs increases one trait or disease in one sex and decreases other trait or disease in the other sex.

sa_snps <- unique(filter(repeated,  has_sa)$SNP)
