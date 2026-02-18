# ---- Neff approach ----------------------------------------------
# Just approximation to power for uni and biv analyses according to Neale's lab empirical
# power curve




neff_power_cal <- function(matadata) {


metadata$neff <- ifelse(!is.na(metadata$Ncase), 1/((1/metadata$Ncase) + (1/metadata$Ncontrol)), metadata$N)


# Univar (h2)

# univar - 4,5K
metadata$neff_power_univ_cat <- rep(NA, length(metadata$neff))
metadata$neff_power_univ_cat <- ifelse(metadata$neff < 4500, "none", metadata$neff_power_univ_cat)
metadata$neff_power_univ_cat <- ifelse(metadata$neff >= 4500 & metadata$neff <  12000,  "SNPh2 0.2", metadata$neff_power_univ_cat)
metadata$neff_power_univ_cat <- ifelse(metadata$neff >= 12000 & metadata$neff<  35000,  "SNPh2 0.1", metadata$neff_power_univ_cat)
metadata$neff_power_univ_cat <- ifelse(metadata$neff >= 35000,  "SNPh2 0.05", metadata$neff_power_univ_cat)

#length(unique(filter(metadata, neff_power_univ_cat=="SNPh2 0.05")$id)) # 830 whole GWAS Atlas


# Bivar (rg)

# bivar - 15 K and 35 K
metadata$neff_power_biv_cat <- rep(NA, length(metadata$neff))
metadata$neff_power_biv_cat <- ifelse(metadata$neff  < 15000, "none", metadata$neff_power_biv_cat)
metadata$neff_power_biv_cat <- ifelse(metadata$neff >= 15000 & metadata$neff <  35000,  "SNPh2 0.2", metadata$neff_power_biv_cat)
metadata$neff_power_biv_cat <- ifelse(metadata$neff >= 35000 & metadata$neff <  90000,  "SNPh2 0.1", metadata$neff_power_biv_cat)
metadata$neff_power_biv_cat <- ifelse(metadata$neff >= 90000,  "SNPh2 0.05", metadata$neff_power_biv_cat)


# Partitioned h2 
metadata$neff_power_part_cat <- rep(NA, length(metadata$neff))
metadata$neff_power_part_cat <- ifelse(metadata$neff  < 25000, "none", metadata$neff_power_part_cat)
metadata$neff_power_part_cat <- ifelse(metadata$neff >= 25000 & metadata$neff <  70000,  "SNPh2 0.2", metadata$neff_power_part_cat)
metadata$neff_power_part_cat <- ifelse(metadata$neff >= 70000 & metadata$neff <  170000,  "SNPh2 0.1", metadata$neff_power_part_cat)
metadata$neff_power_part_cat <- ifelse(metadata$neff >= 170000,  "SNPh2 0.05", metadata$neff_power_part_cat)




#length(unique(filter(metadata, neff_power_biv_cat=="SNPh2 0.05")$id)) # 555 whole GWAS Atlas

metadata

}
