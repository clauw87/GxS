library(data.table)
library(dplyr)

args = commandArgs(T)


res <- args[1]
#res <-  "../3-join_rg_results/real/outputs/genetic-correlations-raw.txt"
res <- "./real/tmp/rg_res"

# read in the joint result logs from ldsc rg tests
# scor = read.table("./rg_res", header=T) 

scor = fread(res, fill=TRUE)
colnames(scor)[1:2] <- c("p1", "p2")
scor = scor[,c("p1","p2","gcov_int", "gencov")]             # retain key headers

# cor = covar12 / sqrt( var11 * var22)

scor$envcov <- scor$gcov_int - scor$gencov

scor$envvarp1 = sapply(1:nrow(scor), function(r) {  filter(scor, p1==scor$p1[r] &  p2==scor$p1[r])$envcov  })
scor$envvarp2 = sapply(1:nrow(scor), function(r) {  filter(scor, p1==scor$p2[r] &  p2==scor$p2[r])$envcov  })
scor$re = sapply(1:nrow(scor), function(r) { scor$envcov[r]/sqrt(scor$envvarp1[r]*scor$envvarp2[r]) }


# 
scor$p1 =  gsub(".munged-sumstats.gz", "", gsub("../1a-munge/real/outputs/","",scor$p1))
scor$p2 =  gsub(".munged-sumstats.gz", "", gsub("../1a-munge/real/outputs/","",scor$p2))



#phen = unique(c(scor$p1, scor$p2))                  # obtain list of all phenotypes (assuming all combinations have been analysed)
#n = length(phen)
#mat = matrix(NA,n,n)                    # create matrix
#rownames(mat) = colnames(mat) = phen    # set col/rownames

#for (i in 1:n) {
#  for (j in 1:n) {
#    mat[i,j] = subset(scor, p1==phen[i] & p2==phen[j] | p2==phen[i] & p1==phen[j] )$gcov_int
#  }
#}

#if (!all(t(mat)==mat)) { mat[lower.tri(mat)] = t(mat)[lower.tri(mat)] }  # sometimes there might be small differences in gcov_int depending on which phenotype was analysed as the outcome / predictor
#mat = round(cov2cor(mat),5)                       # standardise
#write.table(mat, "./real/outputs/sample.overlap.txt", quote=F)   # save


write.table(scor, "./real/outputs/sample.overlap.txt", quote=F, sep="\t", row.names=F)
