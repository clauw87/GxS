if (!(require(data.table))) { install.packages("data.table"); library(data.table)}
if (!(require(dplyr))) { install.packages("dplyr"); library(dplyr)}
if (!(require(stringr))) { install.packages("stringr"); library(stringr)}





# Config -----------------------------------------------------------------------------
args <- commandArgs(trailingOnly=TRUE)

previous_meta <- fread("real/inputs/metadata.txt")
prev_dat <- previous_meta %>% select(sid, Note, PPREV)


metadata_file <- args[1]
output_dir <- args[2]

metadatafilename <- strsplit(metadata_file, "/")[[1]][length(strsplit(metadata_file, "/")[[1]])]
output_name <- strsplit(strsplit(metadata_file, "/")[[1]][length(strsplit(metadata_file, "/")[[1]])], "\\.")[[1]][1]



#source("./real/scripts/prevalence_column.R")
#source("./real/scripts/h2_column.R")
#source("real/scripts/rgcombinations.R")
#source("./real/scripts/call_jian_power_calc.R")

source("./real/scripts/neff_powercalc.R")


# Main ------------------------------------------------------------------------------
metadata <-  fread(metadata_file)


# if GWAS atlas, take pop prevalence from Notes
metadata <- merge(metadata, prev_dat, by="sid", all.x=TRUE)


#metadata <- add_prevalence(metadata)
#filter(metadata, is.na(PPREV), Ncase>1, source!="neales" & source!="elena")
# just 3 cancers which do not have a lot of power
metadata[metadata$sid %in% c("c1f", "c1m")]$PPREV <- c(248/100000, 318/100000)
metadata[metadata$sid %in% c("c2f", "c2m")]$PPREV <- c(1/17, 1/16)
metadata[metadata$sid %in% c("c3f", "c3m")]$PPREV <- 0.04


#UKBK PPREV=SPREV

metadata$SPREV <- metadata$Ncase/(metadata$Ncase+metadata$Ncontrol)

metadata$PPREV <- ifelse(is.na(metadata$PPREV) & metadata$Ncase>1 & (metadata$source=="neales" | metadata$source=="elena"), metadata$SPREV,
metadata$PPREV)

h2 <- fread("../02-ldsc/2-join_h2_results/real/outputs/h2.txt")
metadata <- merge(metadata, h2, by.x="sid", by.y="Trait", all.x=TRUE)

# Add anyway // if not GWAS Atlas, add SNP_h2 calculated with LDSC previously by us
h2$H2_Z <- h2$H2/h2$H2_SE
h2$H2_P <- pnorm(q=h2$H2_Z, lower.tail=FALSE)


# Convert to SNPh2 to liability scale- comparison of differences will be in liability scale
#metadata <- obs_to_l(sid.=NULL, metadata=metadata, use_sample=TRUE, setvalue=NULL)

K <- metadata$PPREV
P <- metadata$SPREV
thresh <- qnorm(K, lower.tail = FALSE)
zv <- dnorm(thresh)
con_factor <- (K)**2*(1-K)**2/(P*(1-P)*zv**2)
con_factor <- K^2 * ( 1 - K)^2 / P / (1-P) / zv^2
metadata$H2L <- metadata$H2 * con_factor

metadata$H2L_VAR <- ( metadata$H2_SE * K^2 * ( 1 - K)^2 / P / (1-P) / zv^2)
metadata$H2L_SE <- sqrt(metadata$H2L_VAR)
metadata$H2L_P <- pchisq(metadata$H2L^2/metadata$H2L_VAR,1,lower.tail=F)


# add obs as H2_L for non bin, so to use one col for h2_diff

metadata$H2L_SE <- ifelse(is.na(metadata$SPREV) & is.na(metadata$H2L),metadata$H2_SE, metadata$H2L_SE )
metadata$H2L_P <- ifelse(is.na(metadata$SPREV) & is.na(metadata$H2L),metadata$H2_P, metadata$H2L_P)
metadata$H2L <- ifelse(is.na(metadata$SPREV) & is.na(metadata$H2L), metadata$H2, metadata$H2L)





# unify SNP liability scale from bt and obs scale for qt in one column, so t test is performed on this column
#metadata$SNPh2_est <- ifelse(!is.na(metadata$SNPh2_l), metadata$SNPh2_l, metadata$SNPh2)
#metadata$SNPh2_est_se <- ifelse(!is.na(metadata$SNPh2_l), metadata$SNPh2_l_se, metadata$SNPh2_s
# disgression
#metadata$vischer_var_h2 <- ifelse(!is.na(metadata$con_factor), var_vg_func(metadata$N)*(metadata$con_factor^2), var_vg_func(metadata$N))
#metadata$vischer_se_h2 <- sqrt(metadata$vischer_var_h2)
# calculate power with Jian functions (univ): depends on N and SNPh2 
# why Visscher's theoretical SNPh2_SE are in many cases not a good approximation here, even for qt where prevalence is not an issue?
# then used actually obtained SE for power calculation



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



#length(unique(filter(metadata, neff_power_biv_cat =="SNPh2 0.05")$sid)) # 17  8 alb
#length(unique(filter(metadata, neff_power_biv_cat %in% c("SNPh2 0.05", "SNPh2 0.1"))$sid)) # 40  18 alb


write.table(metadata, paste0(output_dir, "/", output_name, "_power.txt"), row.names=F, quote=F, sep="\t")

h2_liab <- metadata %>% select(sid, uniqValue, H2L, H2L_SE, H2L_P)
write.table(h2_liab, paste0(output_dir, "/", h2_liab.txt"), row.names=F, quote=F, sep="\t")

# well powered for both univ and biv analyses according to Neff approach
# well_powered_ids <- unique(filter(metadata, neff_power_biv_cat %in% c("SNPh2 0.05", "SNPh2 0.1"))$sid)
# well power as power to detect h2 0.1 > 0.8
well_powered_ids <- unique(filter(metadata, h2_power_diff0.1>0.8)$sid)
write.table(well_powered_ids, paste0(output_dir, "/", output_name, "_well_powered_ids.txt"), row.names=F, col.names=F, quote=F, sep="\t")





#write.table(metadata_biv_power, paste0(output_dir, "/", output_name, "_biv_power.txt"), row.names=F, quote=F, sep="\t")
# bivar: depends on N and rg: do later to check combinations results if necessary
#metadata_biv_power <- biv_power_calc(metadata=metadata)
#write.table(metadata_biv_power, paste0(output_dir, "/", output_name, "_biv_power.txt"), row.names=F, quote=F, sep="\t")




