
library(data.table)
library(dplyr)


power_cal <- function(se, alpha=0.05, diff=0.01){   #diff 0.01 either with 1 or 0
  ncp = (diff^2)/(se^2)
  power <- pchisq(qchisq(alpha, df=1,lower.tail=F), ncp=ncp, df=1, lower.tail=F)
  return(power)
}



rg <- fread("/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/2-ldsc/3-join_rg_results/real/outputs/genetic-correlations.txt")
rg <-  rg %>% select(Trait1, Trait2, GC, GC_SE, PValue) 
colnames(rg) <- c("sid_1", "sid_2", "rg", "rg_se", "pvalue")


h2 <- fread("/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/3-power-calc/real/outputs/metadata_power.txt")

#var_rg_visher <- function(rg, sid_1, sid_2, var_pi=2e-5) {
#        h21 <- h2[sid==sid_1, ]$SNPh2_est
#	h22 <- h2[sid==sid_2, ]$SNPh2_est
#  	N1 <- h2[sid==sid_1, ]$N
#	N2 <- h2[sid==sid_2, ]$N
#	var_rg=(rg^2*( N1^2*h21^2 + N1^2*h22^2)  + 2*h21*h22*N1*N2)/(2*h21^2*h22^2*N1^2*N2^2*var_pi) 
#}




# power for diff with 0 or 1 - univ ie  between sex intra-trait
rg$rg_power0.2 <- power_cal(se=rg$rg_se, diff=0.2)
rg$rg_power0.1 <- power_cal(se=rg$rg_se, diff=0.1)
rg$rg_power0.05 <- power_cal(se=rg$rg_se, diff=0.05)
rg$rg_power0.02 <- power_cal(se=rg$rg_se, diff=0.02)
rg$rg_power0.01 <- power_cal(se=rg$rg_se, diff=0.01)


rg %>% arrange(desc(rg_power0.02))

no_sex_id <- function(string) {
# if last character is m or f, remove
# then if last character is _, remove
if (substr(string, nchar(string), nchar(string)) %in% c("f", "m")) {
string <- substr(string, 1, nchar(string)-1)
if (substr(string, nchar(string), nchar(string)) %in% c("_")) {
string <- substr(string, 1, nchar(string)-1) 
}
}
string
}


rg$id1  <- sapply(rg$sid_1, function(i) {no_sex_id(i)})
rg$id2  <- sapply(rg$sid_2, function(i) {no_sex_id(i)})


rg$id_combi <- paste0(rg$id1, "_", rg$id2)



# save
write.table(rg, "./real/outputs/rg_metadata_power.txt", row.names=FALSE, quote=FALSE, sep="\t") 

# same trait comparisons F vs F
rg %>% filter(id1==id2) # 47 traits
