# Given metadata file from GWAS atlas, create for bt
# sample prevalence column proper columns Ncase and Ncontrol
# population prevalence column from info in Note column


#library(data.table)
#library(stringr)



# add_prevalence() -------------------------------------------------------

add_prevalence <- function(metadata) {

# metadata is GWAS Atlas metadata file, or similary modified version

bin=metadata

# Prevalence in column Note from GWAS atlas
bin$sample_prev <- bin$Ncase/(bin$Ncase + bin$Ncontrol)
bin$pop_prev_present <- sapply(bin$Note, function(t) { str_detect(string = t, pattern = "prevalence:")})
bin$pop_prev <- ifelse(bin$pop_prev_present, bin$Note, NA)
bin$pop_prev <- as.numeric(sapply(bin$Note, function(t) { 
  str_split(str_split(t, pattern = "prevalence: ")[[1]][2], 
            pattern = " ")[[1]][1]
}))

# fix GWAS Atlas original metadata file error: contact later
# max(bin$pop_prev, na.rm = T) # 1.14
# which(bin$pop_prev>1)
# gwas id 4210 has an error, in source cited it says 1 in 7, i.e. 0.14
bin$pop_prev[which(bin$id==4210)] <- 0.14

# Population prevalence not available
# use Finnregistries population prevalences
# using sample prevalence for UKBB risk taking beh
# there are 2 with no pop prevalence and they used sample prevalence
# sum(is.na(bin$pop_prev)) # 5
#bin[is.na(bin$pop_prev)] # PGC cross disorder and Ever used cannabis

# get a value for available prevalence, 
# prioritising population one when available, but using sample one when not.

# use gwas atlas, then manually entered from FinnRegistries in PPREV column
#bin$avail_prev <- ifelse(!(is.na(bin$pop_prev)), bin$pop_prev, bin$sample_prev)
bin$pop_prev <- ifelse(!(is.na(bin$pop_prev)), bin$pop_prev, bin$PPREV)



# convert obs to l scale for that one that we had to fix:
K <- bin[which(bin$id==4210),]$pop_prev
P <- bin[which(bin$id==4210),]$sample_prev
thresh <- qnorm(K, lower.tail = FALSE)
con_factor <- (K)**2*(1-K)**2/(P*(1-P)*dnorm(thresh)**2)
bin[which(bin$id==4210),]$SNPh2_l <- bin[which(bin$id==4210),]$SNPh2 * con_factor



# add SNPh2_l colmumn NA filled, if not present in the metadata table already (it is now)
if ( !("SNPh2_l" %in% colnames(bin)) ) {
bin$SNPh2_l <- rep(NA, nrow(bin))
bin$SNPh2_l <- as.numeric(bin$SNPh2_l)
}
bin
}



# obs_to_l() -------------------------------------------------------

# if pop prevalence not	present but and we want to use sample prevalence 
# use  use_sample=TRUE

obs_to_l <- function(sid.=NULL, metadata, use_sample=FALSE, setvalue=NULL) {

bin=metadata
bin$SNPh2_l <- rep(NA, nrow(bin))

if (is.null(bin$pop_prev)) {
bin$pop_prev <- rep(NA, nrow(bin))
}

# add sample prevalence column - there is one there now, but OK
bin$sample_prev <- bin$Ncase/(bin$Ncase + bin$Ncontrol)

if (is.null(sid.)) {
w <- bin[ (is.na(bin$SNPh2_l) & is.na(bin$pop_prev) ),  ]$sid
} else {
w <- sid.
}
if (use_sample) {
K <- ifelse(is.na(bin$pop_prev), bin$sample_prev, bin$pop_prev)
} else {
K <- bin$pop_prev
}

P <- bin$sample_prev
thresh <- qnorm(K, lower.tail = FALSE)
con_factor <- (K)**2*(1-K)**2/(P*(1-P)*dnorm(thresh)**2)

if ( !is.null(setvalue) ) {
SNPh2_l <- rep(setvalue, length(bin$SNPh2)) * con_factor
} else {
SNPh2_l <- bin$SNPh2 * con_factor
}

if ( !is.null(setvalue) ) {
SNPh2_l_se <- rep(setvalue, length(bin$SNPh2_se)) * con_factor
} else {
SNPh2_l_se <- bin$SNPh2_se * con_factor
}


bin$SNPh2_l <- as.numeric(SNPh2_l)
bin$SNPh2_l_se <- as.numeric(SNPh2_l_se)
bin$con_factor <- as.numeric(con_factor)


bin[ which(bin$sid %in% w), ]$SNPh2_l <- as.numeric(SNPh2_l[ which(bin$sid %in% w) ])
bin[ which(bin$sid %in% w), ]$SNPh2_l_se <- as.numeric(SNPh2_l_se[ which(bin$sid %in% w) ])
bin[ which(bin$sid %in% w), ]$con_factor <- as.numeric(con_factor[ which(bin$sid %in% w) ])

#metadata$bin[is.na(bin$con_factor)] <- 1

if ( !is.null(setvalue) ) {
return(bin[ which(bin$sid %in% w), ])  # c("SNPh2_l", "SNPh2_l_se", "con_factor")
} else {
return(bin)
}

}




