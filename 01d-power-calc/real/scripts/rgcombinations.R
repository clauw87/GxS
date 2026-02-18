#phenocomb_file <-"../2-ldsc/3-rg/real/tmp/phenoscomb"
#phenocomb <- fread(phenocomb_file, header=F)
#phenocomb$V1 <- sub(".munged-sumstats.gz", "", sub("../1a-munge/real/outputs/", "", comb$V1))
#phenocomb$V2 <- sub(".munged-sumstats.gz", "", sub("../1a-munge/real/outputs/", "", comb$V2))


rgres_file <- "../2-ldsc/3-join_rg_results/real/outputs/genetic-correlations.txt"
rgres <- fread(rgres_file, header=F)
colnames(rgres) <- c("Trait1",  "Trait2",  "Intercept", "Intercept_SE",   "GC",   "GC_SE", "PValue")


get_rg <- function(combination=s, rgres.=rgres, ...) {
s <- combination
# Find rg of comnination
rg <- filter(rgres., (Trait1==s[1] & Trait2==s[2])  | (Trait1==s[2] & Trait2==s[1]))$GC

rg

}
