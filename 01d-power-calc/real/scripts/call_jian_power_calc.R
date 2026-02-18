# Power calculation added as column to metadata file of summary statistiscs
# Jian's (Vischer´s) approach
# ------------------------- ----------------------------------------------

source("./real/scripts/jian_powercalc.R")

# for the calculations, the true SNP-h2/ SNP_h2_l assumed in the population (parameter hsq) 
# was set to 0.02, since it is the min in any sumstats selected for now.

# the variance explained by the SNPs, although depend on the number of SNPs
# and their correlation structure, in this approach it is approximated to 
# its empirical value for genome wide studies covering common SNPs (authors) 
# but also, we have pre-filtered to 500K SNPs

# Walter Raymonds recommends this power calc for LDSC; 
# LDSC people also have the rule of thumb 
# SNPh2_z > 4 for correlation analyses and SNPh2_z > 7 for partitioned h2
# We will work with SNPh2_z > 4 for bivariate analysis to be sure.



# Functions -------------------------------------------------------------
 

# power_univ()
# internal to univ_power_calc

power_univ <- function(sid., metadata.=metadata, var_pi.=2e-5, alpha.=0.05, ...) {


# sid. is an stratified id value in sid column from metadata
# which is column- harmonised as from within
# by uni_power_calc 

if ( length(metadata[sid==sid., ]$Ncase)>0 &  is.na(metadata[sid==sid., ]$Ncase) ) {
# treat like a qt
power <- calcUniQt(
	n=metadata[sid==sid., ]$N,
        #hsq=metadata[sid==sid., ]$SNPh2,
        hsq=0.02, 
	alpha = alpha.,
        var_pi=var_pi.
        )$power
} else if (length(metadata[sid==sid., ]$Ncase)>0 &  !is.na(metadata[sid==sid., ]$Ncase)  ){
# trait like a bt (Case Control)
power <- calcUniCc(ncase = metadata[sid==sid., ]$Ncase,
            ncontrol = metadata[sid==sid., ]$Ncontrol,
            #hsq = metadata[sid==sid., ]$SNPh2_l,
	    hsq = obs_to_l(sid=sid., metadata=metadata, use_sample=TRUE, setvalue=0.02),
            K = metadata[sid==sid., ]$avail_prev,
            alpha = alpha.,
            var_pi = var_pi.)$power
} 

power

}





# power_biv()
# internal to biv_power_calc

power_biv <- function(s=NULL, id1=NULL, id2=NULL, metadata., var_pi.=2e-5, alpha.=0.05, overlap.=TRUE) {

# s is a vector of two values id1 and id2
# alternatively provide id1, id2
# id is a value in id column from metadata
# which is column- harmonised as from within
# by uni_power_calc or bi_power_calc

if (is.null(s)) {

if (!is.null(id1) & !is.null(id2)) {
s <- c(id1, id2)
} else {
stop("Error: either s or id1 and id2 need to be provided")
}

}

if (is.null(id1) | is.null(id2)) {
id1 <- s[1]
id2 <- s[2]
}

if ( is.na(metadata[sid==id1, ]$Ncase)  & is.na(metadata[sid==id2, ]$Ncase)) {
# treat like 2 qt
power <- calcBiQt(n1=metadata[metadata$sid==id1, ]$N,
           n2 = metadata[metadata$sid==id2, ]$N,  
           #hsq1 =metadata[metadata$sid==id1, ]$SNPh2, 
           #hsq2 =metadata[metadata$sid==id2, ]$SNPh2,
           hsq1 = 0.02,
           hsq2 = 0.02,
           rg = 0.1,
           rp = rg*0.7,  
           alpha = alpha.,
           var_pi = var_pi.)$power
} else if (!is.na(metadata[sid==id1, ]$Ncase) & !is.na(metadata[sid==id1, ]$Ncase)) {
# trait like 2 bt
power <- calcBiCc(ncase1 = metadata[metadata$sid==id1, ]$Ncase,
         ncase2 = metadata[metadata$sid==id2, ]$Ncase,    
         ncontrol1 = metadata[metadata$sid==id1, ]$Ncontrol,
         ncontrol2 = metadata[metadata$sid==id2, ]$Ncontrol,
         hsq1 = obs_to_l(sid.=id1, metadata=metadata, use_sample=TRUE, setvalue=0.02),
         hsq2 = obs_to_l(sid.=id2, metadata=metadata, use_sample=TRUE, setvalue=0.02),
	 #hsq1 = metadata[metadata$sid==id1, ]$SNPh2_l,
         #hsq2 = metadata[metadata$sid==id2, ]$SNPh2_l, 
         K1 =  metadata[metadata$sid==id1, ]$avail_prev,
         K2 = metadata[metadata$sid==id2, ]$avail_prev,
         rg =  0.1,
         overlap  = overlap., # boolean 
         alpha = alpha.,
         var_pi = var_pi.)$power

} else if (is.na(metadata[sid==id1, ]$Ncase) & !is.na(metadata[sid==id2, ]$Ncase)) {
# treat like 1 qt(id1) and 1 bt(id2)
power <- calcBiQtCc(
    n = metadata[metadata$sid==id1, ]$N,  # qt  
    ncase = metadata[metadata$sid==id2, ]$Ncase,
    ncontrol = metadata[metadata$sid==id2, ]$Ncontrol,
    #hsq1  = metadata[metadata$sid==id1, ]$SNPh2,
    hsq1 = 0.02,
    #hsq2  = metadata[metadata$sid==id2, ]$SNPh2_l,
    hsq2 = obs_to_l(sid=id2, metadata=metadata, use_sample=TRUE, setvalue=0.02),
    K = metadata[metadata$sid==id2, ]$avail_prev, 
    rg  =  0.1,    
    overlap = overlap.,
    alpha = alpha.,
    var_pi = var_pi.
    )$power
} else if ( !(is.na(metadata[sid==id2, ]$Ncase))  & is.na(metadata[sid==id1, ]$Ncase)  ) {
# treat like 1 qt(id2) and 1 bt(id1)
power <- calcBiQtCc(
    n = metadata[metadata$sid==id2, ]$N,  # qt
    ncase = metadata[metadata$sid==id1, ]$Ncase,
    ncontrol = metadata[metadata$sid==id1, ]$Ncontrol,
    #hsq2  = metadata[metadata$sid==id2, ]$SNPh2,
    hsq2  = 0.02,
    #hsq1  = metadata[metadata$sid==id1, ]$SNPh2_l,
    hsq1 = obs_to_l(sid=id1, metadata=metadata, use_sample=TRUE, setvalue=0.02),
    K = metadata[metadata$sid==id1, ]$avail_prev,
    rg  =  0.1,   
    overlap = overlap.,
    alpha = alpha.,
    var_pi = var_pi.
    )$power
} 

power

}



# Univariate
# ------------------------------------------------------------------

uni_power_calc   <- function(
		metadata, alpha=0.05, var_pi=2e-5,
		bonf= FALSE, sid="sid", N="N", 
		Ncase="Ncase", Ncontrol="Ncontrol",
		SNPh2="SNPh2", SNPh2_l="SNPh2_l", ...) {
   
# metadata is a df that has and id column and columns N, and Ncases 
# and Ncontrols  for bt and SNPh2 or SNPh2_l for bt

# metadata names are set to expected ones by function to work with dplyr and stuff:
colnames(metadata)[which(colnames(metadata)==sid)] <- "sid"
colnames(metadata)[which(colnames(metadata)==N)] <- "N"
colnames(metadata)[which(colnames(metadata)==Ncase)] <- "Ncase"
colnames(metadata)[which(colnames(metadata)==Ncontrol)] <- "Ncontrol"
colnames(metadata)[which(colnames(metadata)==SNPh2)] <- "SNPh2"

# because there are 2 at least that use the same code for males and females, use sid: id_sex
#metadata$sid <- paste0(metadata$id, metadata$sex)

metadata[["power_univ"]] <- sapply(metadata$sid, function(sid) { power_univ(sid.=sid, metadata.=metadata, var_pi.=var_pi, alpha.=alpha)})

metadata

}





# ------------------------------------------------------------------
# Bivariate
# For a list of traits ids, calculate power of all 
# bivariate combinations and create a table with the
# combinations values


# Both quantitative (two qt traits, or same qt across sexes)---------

# rg = genetic correlation
# rp = phenotypic correlation
# overlap = whether or not the traits are measured on the same samples





biv_power_calc   <- function(combinations=NULL,
                metadata, alpha=0.05, var_pi=2e-5,
                bonf= FALSE, sid="sid", N="N",
                Ncase="Ncase", Ncontrol="Ncontrol",
                SNPh2="SNPh2", SNPh2_l="SNPh2_l") {

# if combinations list is not passed, all combinations are done
# should be given as a file where in every line a pair of ids is given
# white space separated


if (!is.null(combinations)) {
#combis <- as.list(fread("combinations.txt", header=F)$V1) # a list of two elements verctors
} else {
combis <- combinat::combn(metadata$sid, 2, simplify = F) 
}

# metadata names are set to expected ones by function to work with dplyr and stuff:
colnames(metadata)[which(colnames(metadata)==sid)] <- "sid"
colnames(metadata)[which(colnames(metadata)==N)] <- "N"
colnames(metadata)[which(colnames(metadata)==Ncase)] <- "Ncase"
colnames(metadata)[which(colnames(metadata)==Ncontrol)] <- "Ncontrol"
colnames(metadata)[which(colnames(metadata)==SNPh2)] <- "SNPh2"


powercomb <- sapply(combis, function(s) { power_biv(id1=s[1], id2=s[2], var_pi.=var_pi, alpha.=alpha, overlap=TRUE) })
names(powercomb) <- sapply(combis, function(s) { paste0(s, collapse=" ") })

#powercomb_df <- data.frame(powercomb)
powercomb_df <- data.frame(names(powercomb), powercomb)
colnames(powercomb_df) <- c("comb", "power")

powercomb_df

}




