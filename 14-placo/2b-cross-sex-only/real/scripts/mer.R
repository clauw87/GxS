library(data.table)
library(dplyr)

args <- commandArgs(T)

meta_file <- args[1]
cross_file <- args[2]
ct_file <- args[3]
indir <- args[4]
outdir <- args[5]

#meta_file <- "/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains_updated.txt"
#cross_file <- "/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/1-run-placo/real/tmp/crosscross"
#ct_file <- "/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/1-run-placo/real/tmp/combipairs"
#outdir <- "real/outputs"


suffix <- ".placo"

meta <- fread(meta_file)
cross <- fread(cross_file, header=F)
colnames(cross) <- c("sid1", "sid2")
cross <- filter(cross, sid1 %in% meta$sid & sid2 %in% meta$sid)


ct <- fread(ct_file, header=F)
colnames(ct) <- c("sid1", "sid2")
ct <- filter(ct, sid1 %in% meta$sid & sid2 %in% meta$sid)

cross$traitname1 <- sapply(1:nrow(cross), function(r) {  filter(meta, sid==cross$sid1[r])$trait_name_clean} )
cross$traitname2 <- sapply(1:nrow(cross), function(r) {  filter(meta, sid==cross$sid2[r])$trait_name_clean} )

cross$sex1 <- sapply(1:nrow(cross), function(r) {  filter(meta, sid==cross$sid1[r])$sex} )
cross$sex2 <- sapply(1:nrow(cross), function(r) {  filter(meta, sid==cross$sid2[r])$sex} )

cross <- filter(cross, sex1!=sex2 & traitname1!=traitname2) # 2549 

cross$pair_sid <- sapply(1:nrow(cross), function(r) { paste0(cross$sid1[r], ":", cross$sid2[r]) })

ct$traitname1 <- sapply(1:nrow(ct), function(r) {  filter(meta, sid==ct$sid1[r])$trait_name_clean} )
ct$traitname2 <- sapply(1:nrow(ct), function(r) {  filter(meta, sid==ct$sid2[r])$trait_name_clean} )

ct$sex1 <- sapply(1:nrow(ct), function(r) {  filter(meta, sid==ct$sid1[r])$sex} )
ct$sex2 <- sapply(1:nrow(ct), function(r) {  filter(meta, sid==ct$sid2[r])$sex} )

ct <- filter(ct, sex1==sex2 & traitname1!=ct$traitname2)
ct$pair_sid <- sapply(1:nrow(ct), function(r) { paste0(ct$sid1[r], ":", ct$sid2[r]) })




cross$pair_name <- sapply(1:nrow(cross), function(r) {  
       paste0( sort(c(cross$traitname1[r], cross$traitname2[r])), collapse=":" )    })

ct$pair_name <- sapply(1:nrow(ct), function(r) {
       paste0( sort(c(ct$traitname1[r], ct$traitname2[r])), collapse=":" )    })  



for (pn in unique(cross$pair_name)) {

#pn <- "ADHD:Alzheimer's Disease"

sid1_1 = filter(cross, pair_name==pn)$sid1[1]
sid2_1 = filter(cross, pair_name==pn)$sid2[1]
cs_1 = fread(paste0(indir, sid1_1, ":", sid2_1, suffix))

sid1_2 = filter(cross, pair_name==pn)$sid1[2]
sid2_2 = filter(cross, pair_name==pn)$sid2[2]
cs_2 = fread(paste0(indir, sid1_2, ":", sid2_2, suffix))


cs_1 <- filter(cs_1, p.placo < 5e-08)
cs_2 <- filter(cs_2, p.placo < 5e-08)
# SNPs significant in either cross-sex pair for the pair_name 
cs_snps <- c(cs_1$SNP, cs_2$SNP)


ws_pairs <- filter(ct, pair_name==pn)

ws_1 <-  fread(paste0(indir, ws_pairs$sid1[1], ":", ws_pairs$sid2[1], suffix))
ws_2 <-  fread(paste0(indir, ws_pairs$sid1[2], ":", ws_pairs$sid2[2], suffix))
# SNPs tested in both pairs
ws_common <- unique(intersect(ws_1$SNP, ws_2$SNP))

ws_1_rmsnps <- filter(ws_1, !(SNP %in% ws_common ) | ( !is.null(p.placo) & p.placo < 0.05))$SNP
ws_2_rmsnps <- filter(ws_2, !(SNP %in% ws_common ) | (!is.null(p.placo) & p.placo < 0.05))$SNP
# rm SNP that are either not present in both or are significant in either within sex pairs for the pair_name
ws_rmsnps <- c(ws_1_rmsnps, ws_2_rmsnps)

cs_only_snps <- setdiff(cs_snps, ws_rmsnps) 

pncode <- paste0(sid1_1, ":", sid2_1, "_or_", sid1_2,":", sid2_2 )

if (length(cs_only_snps) >0 ) {
write.table(cs_only_snps, file=paste0(outdir, "/", pncode), row.name=F, col.names=F, sep="\n", quote=F)
}

}



  
