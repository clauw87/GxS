library(data.table)
library(dplyr)


args <- commandArgs(trailingOnly=TRUE)

metadata_file <- args[1]
h2_file <- args[2]
output_dir <- args[3]

# gbd binary requested
#gbd <- fread("real/inputs/IHME-GBD_2021_DATA-0c7d54b3-1.csv")
gbd <- fread("/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01d-power-calc/real/inputs/IHME-GBD_2021_DATA-08b27645-1.csv")
gbd$PPREV <- gbd$val/100000
unique(gbd$cause_name)


# gwas atlas
previous_meta <- fread("/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01d-power-calc/real/inputs/metadata.txt")
prev_dat <- previous_meta %>% select(sid, Note, PPREV)
# filter(prev_dat, sid=="r5f")


metadatafilename <- strsplit(metadata_file, "/")[[1]][length(strsplit(metadata_file, "/")[[1]])]
output_name <- strsplit(strsplit(metadata_file, "/")[[1]][length(strsplit(metadata_file, "/")[[1]])], "\\.")[[1]][1]

source("/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01d-power-calc/real/scripts/neff_powercalc.R")


# Main ------------------------------------------------------------------------------
metadata <-  fread(metadata_file)


# if GWAS atlas, take pop prevalence from Notes
#metadata <- merge(metadata, prev_dat, by="sid", all.x=TRUE)

metadata$PPREV <- rep(0, nrow(metadata))


# manually add prevalences of some diseases
# just 3 cancers which do not have a lot of power
metadata[metadata$sid %in% c("c1f", "c1m")]$PPREV <- c(248/100000, 318/100000)
metadata[metadata$sid %in% c("c2f", "c2m")]$PPREV <- c(1/17, 1/16)
metadata[metadata$sid %in% c("c3f", "c3m")]$PPREV <- c(0.04,0.04)
metadata[metadata$sid %in% c("ADr1uf", "ADr1um")]$PPREV <- c(0.071,0.033)

# 2019 DATA GBD
# CVD
metadata[sid=="a13f",]$PPREV <- filter(gbd, cause_name=="Cardiovascular diseases" & sex_name=="Female")$PPREV  #0.1138
metadata[sid=="a13m",]$PPREV <- filter(gbd, cause_name=="Cardiovascular diseases" & sex_name=="Male")$PPREV  # 0.111
# SCZ
metadata[sid=="r5f",]$PPREV <- filter(gbd, cause_name=="Schizophrenia" & sex_name=="Female")$PPREV
metadata[sid=="r5m",]$PPREV <- filter(gbd, cause_name=="Schizophrenia" & sex_name=="Male")$PPREV
# AD
metadata[sid=="ADr1uf",]$PPREV <- filter(gbd, cause_name=="Alzheimer's disease and other dementias"  & sex_name=="Female")$PPREV
metadata[sid=="ADr1um",]$PPREV <- filter(gbd, cause_name=="Alzheimer's disease and other dementias"  & sex_name=="Male")$PPREV
# ADHD
metadata[sid=="a9f",]$PPREV <- filter(gbd, cause_name=="Attention-deficit/hyperactivity disorder"   & sex_name=="Female")$PPREV
metadata[sid=="a9m",]$PPREV <- filter(gbd, cause_name=="Attention-deficit/hyperactivity disorder"   & sex_name=="Male")$PPREV
# PD
metadata[sid=="a7f",]$PPREV <- filter(gbd, cause_name=="Parkinson's disease"  & sex_name=="Female")$PPREV
metadata[sid=="a7m",]$PPREV <- filter(gbd, cause_name=="Parkinson's disease"  & sex_name=="Male")$PPREV
# Hem malig
metadata[sid=="c1f",]$PPREV <- filter(gbd, cause_name=="Myelodysplastic, myeloproliferative, and other hematopoietic neoplasms" & sex_name=="Female")$PPREV
metadata[sid=="c1m",]$PPREV <- filter(gbd, cause_name=="Myelodysplastic, myeloproliferative, and other hematopoietic neoplasms" & sex_name=="Male")$PPREV
# Colorectal cancer
metadata[sid=="c3f",]$PPREV <- filter(gbd, cause_name=="Colon and rectum cancer" & sex_name=="Female")$PPREV
metadata[sid=="c3m",]$PPREV <- filter(gbd, cause_name=="Colon and rectum cancer" & sex_name=="Male")$PPREV
# Lung cancer
metadata[sid=="c2f" ,]$PPREV <- filter(gbd, cause_name=="Tracheal, bronchus, and lung cancer"  & sex_name=="Female")$PPREV
metadata[sid=="c2m" ,]$PPREV <- filter(gbd, cause_name=="Tracheal, bronchus, and lung cancer"  & sex_name=="Male")$PPREV
# MD
metadata[sid=="r10f",]$PPREV <-  filter(gbd, cause_name=="Major depressive disorder"  & sex_name=="Female")$PPREV
metadata[sid=="r10m",]$PPREV <-  filter(gbd, cause_name=="Major depressive disorder"  & sex_name=="Male")$PPREV
# T2D
metadata[sid=="a8f",]$PPREV <-  filter(gbd, cause_name=="Diabetes mellitus type 2" & sex_name=="Female")$PPREV
metadata[sid=="a8m",]$PPREV <-  filter(gbd, cause_name=="Diabetes mellitus type 2" & sex_name=="Male")$PPREV


# SPREV
metadata$SPREV <- metadata$Ncase/(metadata$Ncase+metadata$Ncontrol)


#------------------------------------------------------------------------------------------------------------------------
# Assign Atlas PPREV
#metadata$PPREV <- sapply(1:nrow(metadata), function(i) { ifelse( (is.na(metadata$PPREV[i]) | metadata$PPREV[i]==0 )& !is.na(metadata$Ncase[i]) & metadata$source[i]=="atlas", 
#        filter(prev_dat, sid==metadata$sid[i])$PPREV, metadata$PPREV)
#})

# Assign UKBK PPREV = SPREV
#metadata$PPREV <- ifelse(is.na(metadata$PPREV) & metadata$Ncase>1 & (metadata$source=="neales" | metadata$source=="elena" | metadata$source=="elenas"),
#                  metadata$SPREV, metadata$PPREV)
metadata$PPREV <- ifelse(metadata$source=="neales" | metadata$source=="elena" | metadata$source=="elenas", metadata$SPREV, metadata$PPREV)


# Assign manually entered to prev_data file for remanining requested
tf <- filter(metadata, PPREV==0, source=="requested", !(is.na(Ncase)))$sid
for (t in tf) {
metadata[sid==t,]$PPREV <- filter(prev_dat, sid==t)$PPREV
}

h2 <- fread(h2_file)
h2$H2_Z <- h2$H2/h2$H2_SE
h2$H2_P <- pnorm(q=h2$H2_Z, lower.tail=FALSE)

metadata <- merge(metadata, h2, by.x="sid", by.y="Trait", all.x=TRUE)


# Convert bin to liab
K <- metadata$PPREV
P <- metadata$SPREV
thresh <- qnorm(K, lower.tail = FALSE)
zv <- dnorm(thresh)
#con_factor <- (K)**2*(1-K)**2/(P*(1-P)*zv**2)
#con_factor <- K^2 * ( 1 - K)^2 / P / (1-P) / zv^2
con_factor <- K*( 1 - K)*K*( 1 - K) / ( zv^2*P*(1-P)  )
metadata$H2L <- metadata$H2 * con_factor

metadata$H2L_VAR <- ( metadata$H2_SE * con_factor )^2
metadata$H2L_SE <- sqrt(metadata$H2L_VAR)
metadata$H2L_P <- pchisq(metadata$H2L^2/metadata$H2L_VAR,1,lower.tail=F)


# add obs as H2_L for non bin, so to use one col for h2_diff
metadata$H2L_SE <- ifelse(is.na(metadata$SPREV) & is.na(metadata$H2L),metadata$H2_SE, metadata$H2L_SE )
metadata$H2L_P <- ifelse(is.na(metadata$SPREV) & is.na(metadata$H2L),metadata$H2_P, metadata$H2L_P)
metadata$H2L <- ifelse(is.na(metadata$SPREV) & is.na(metadata$H2L), metadata$H2, metadata$H2L)


h2_liab <- metadata %>% select(sid, uniqValue, sex, H2, H2_SE, H2_P, H2L, H2L_SE, H2L_P, SPREV, PPREV)
#h2_liab$trait_clean <- sapply(h2_liab$uniqValue, function(t) { strsplit(x=t, split="(", fixed=TRUE)[[1]][1] })

write.table(h2_liab, paste0(output_dir, "/", "h2_liab.txt"), row.names=F, quote=F, sep="\t")


# ----------------------------------


# power calc function general: checks any difference being different from 0
power_cal <- function(se, alpha=0.05, diff=0.01){   #diff 0.01 either with 1 or 0
  ncp = (diff^2)/(se^2)
  power <- pchisq(qchisq(alpha, df=1,lower.tail=F), ncp=ncp, df=1, lower.tail=F)
  return(power)
}

# power cal for different h2 desired differences (0.01, 0.02, 0.05)
metadata$H2_power_diff0.1 <- power_cal(metadata$H2_SE, diff=0.1)
metadata$H2_power_diff0.05 <- power_cal(metadata$H2_SE, diff=0.05)
metadata$H2_power_diff0.02 <- power_cal(metadata$H2_SE, diff=0.02)
metadata$H2_power_diff0.01 <- power_cal(metadata$H2_SE, diff=0.01)

# calculate power based on Neff approach (univ and biv categories)
metadata <- neff_power_cal(metadata)



write.table(metadata, paste0(output_dir, "/", output_name, "_power.txt"), row.names=F, quote=F, sep="\t")



