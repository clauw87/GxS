


mat <- as.matrix(fread("real/outputs/across.mat"), rownames=1)

mat <- mat[which(rownames(mat)!="joined"),]
sum(mat["ADr1um:ADr1uf" ,]) # 14

mat[,which(mat["ADr1um:ADr1uf" ,]==1)]


traits_with_sbsnps <- names(rowSums(mat))[rowSums(mat)>0] # all 54


colSums(mat[,which(mat["ADr1um:ADr1uf" ,]==1)]) # all 1 these are not shared 


colSums(mat[,which(mat["r5m:r5f" ,]==1)]) # 3, eg "rs1912151" shared with l4m:l4f and 175m:177f


rep_snps <- names(colSums(mat))[colSums(mat)>1]

rep_snps_traits <- sapply(rep_snps, function(s) { names(mat[ ,s][mat[ ,s]>0])} )

# $rs9611015
# [1] "a13m:a13f" "r4m:r4f"  

# $rs374796059
# [1] "l2m:l2f" "l3m:l3f"


# $rs17216693
# [1] "a8m:a8f" "l1m:l1f" "l2m:l2f" "l3m:l3f" "l4m:l4f" "l5m:l5f"


#$rs2287997
#[1] "bm5m:bm5f" "l4m:l4f"  


# $rs2058908
#[1] "138m:139f" "181m:183f" "a28m:a28f"


# $rs34775748
# [1] "a30m:a30f" "a9m:a9f"   "bm4m:bm4f" "l2m:l2f"  


# $rs28929474
# [1] "4212m:4213f" "l2m:l2f"     "l3m:l3f"     "l5m:l5f"  

# $rs1867370
# [1] "a1m:a1f"   "a29m:a29f"

# $rs58116261
# [1] "bm2m:bm2f" "l1m:l1f"  


# $rs1519126
# [1] "a9m:a9f" "l1m:l1f" "l3m:l3f" "l5m:l5f"


#traits_with_rep <- names(rowSums(mat[, which(colnames(mat) %in% rep_snps)]))[rowSums(mat[, which(colnames(mat) %in% rep_snps)])>0]

