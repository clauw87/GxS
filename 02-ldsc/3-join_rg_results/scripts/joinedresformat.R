library(data.table)
library(dplyr)
library(stringr)
library(xtable)

args <- commandArgs(T)

res_file <- args[1]
#combis_file <- args[2]
meta_file <- args[2]
powered_file <- args[3]
# do this instead of run.sh since some get overloaded
#all.files <- list.files("./real/tmp", full.names=T)
#mylist <- lapply(all.files, fread)
#mydata <- do.call("rbind", mylist)
#mydata$Trait1 <- gsub("../1a-munge/real/outputs/", "", gsub(".munged-sumstats.gz", "",  mydata$p1))
#mydata$Trait2 <- gsub("../1a-munge/real/outputs/", "", gsub(".munged-sumstats.gz", "",  mydata$p2))
#mydata <- select(mydata, Trait1, Trait2, rg, se, p)
#colnames(mydata) <- c("Trait1", "Trait2", "GC", "GC_SE", "PValue")
#write.table(mydata, "./real/outputs/genetic-correlations.txt", quote=FALSE, row.name=FALSE, sep="\t")

# No, names do not split well at "."
#combis <- fread(combis_file, header=F, sep=" ")
#combis$sid1 <- sapply(combis$V1, function(e) { strsplit(basename(e), ".", fixed=T)[[1]][1]})
#combis$sid2 <- sapply(combis$V2, function(e) { strsplit(basename(e), ".", fixed=T)[[1]][1]})
#combis$sid_pair <- sapply(1:nrow(combis), function(i) { paste0(c(combis$sid1[i], combis$sid2[i]), collapse=":") })
#rg <- fread("../genetic-correlations.txt")
rg <- fread(res_file)
colnames(rg)[1:2] <- c("Trait1", "Trait2")
# save it with columns fixed
write.table(rg, "../genetic-correlations.txt", sep="\t", row.names=F, quote=F)


rg_traits <- unique(c(rg$Trait1, rg$Trait2)) # 
length(rg_traits) # applied to combinations


meta <- fread(meta_file)
#meta <- fread("../../joined_metadata_domains.txt")
#meta <- fread("/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt")


# SID pairs
rg$sid_pair <- sapply(1:nrow(rg), function(i) { paste0(c(rg$Trait1[i], rg$Trait2[i]), collapse=":") })
#rg$sid_pair2 <- sapply(1:nrow(rg), function(i) { paste0(c(rg$Trait2[i], rg$Trait1[i]), collapse=":") })

# setdiff(rg$sid_pair, combis$sid_pair)
# setdiff(combis$sid_pair,rg$sid_pair)
# there is an error with em_1707-0 , fixed script bc of this


#rg <- filter(rg, sid_pair %in% combis$sid_pair)

# filter to metadata ones
rg <- filter(rg, Trait1 %in% meta$sid & Trait2 %in% meta$sid)


# powered (h2 z>=2)
#powered_ids <- fread("../2-join_h2_results/real/outputs/h2_powered_2.txt" , header=F)$V1
powered_ids <- fread(powered_file, header=F)$V1

# 308 , so 154 traits
rg <- filter(rg , Trait1 %in% powered_ids, Trait2 %in% powered_ids) 

# z>=2
length(unique(c(rg$Trait1, rg$Trait2))) # 98 sids, 49 traits



# Trait names
rg$Trait1_name <- sapply(rg$Trait1, function(s) { as.character(unique(filter(meta, sid ==s)$uniqValue)) })
rg$Trait2_name <- sapply(rg$Trait2, function(s) { as.character(unique(filter(meta, sid ==s)$uniqValue)) })

rg$sex1  <- sapply(rg$Trait1, function(e) { filter(meta, sid==e)$sex} )
rg$sex2  <- sapply(rg$Trait2, function(e) { filter(meta, sid==e)$sex} )
rg$pair_sids <- paste0(rg$Trait1, ":", rg$Trait2)


# no, in case same trait pair is swaped in the sexes
#rg$pair_name <- paste0(rg$Trait1_name, ":", rg$Trait2_name)
# alphabetically sorted pair name
rg$pair_name <- sapply(1:nrow(rg), function(i) {
paste0(   sort( c(rg$Trait1_name[i], rg$Trait2_name[i])) , collapse=":")
} )


# remove elenas
# remove included elenas
#library(stringr)
#rg <- filter(rg, !(  str_detect(Trait1, "em_") | str_detect(Trait2, "em_") | str_detect(Trait1, "ef_") | str_detect(Trait2, "ef_")))
#rg_traits <- unique(c(rg$Trait1, rg$Trait2)) #  110 sids



write.table(rg, "./real/outputs/formatted_rg_res.txt", sep="\t", row.names=F, quote=F)

cc <- sapply(unique(rg$pair_name), function(e) { length(filter(rg, pair_name==e)$pair_sids) })
sum(cc==1) 
sum(cc==2) 
sum(cc==3)
