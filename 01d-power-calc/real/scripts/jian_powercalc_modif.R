# Power calculation of GWASes for GxS using 


# R funtions by [Jian Yang](https://gcta.freeforums.net/user/1) from
# [https://gcta.freeforums.net/thread/164/gcta-greml-power-calculator](https://gcta.freeforums.net/thread/164/gcta-greml-power-calculator)



# --------------------------------------------------
#  Using the var_vg precalculated for for a trait (fucntion below)
# as var_vg <- var_vg_func(n, var_pi)
# use as argument for function




# Function for a quantitative trait
# n = sample size
# hsq = variance explained by all SNPs
# alpha = significance level
# var_pi = variance of the off-diagonal elements of the GRM
# The output are: se (standard error), ncp (non-centrality parameter) and power
# Different from 0 default ncp=1, different from other trait h2 
calcUniQt <- function(
    #n  =1000,
    hsq1  =0.22,
    hsq0 = NULL, # hsq1 - 0.02,      # (optionally desired h2 d different from 0)
    alpha =0.05,
    var_pi=2e-5,
    var_vg1=var_vg_func(),
    var_vg0=NULL,    # optionally other trait
    ncp=0           # by default 0, otherwise calculated from var_vg1 and hsq1 
){
  l <- list()
  var_vg1 <- var_vg1
  var_vg' <- var_vg0
  l$se1 <- sqrt(var_vg1)
  l$se0 <- sqrt(var_vg0)
  l$ncp1 <- hsq1^2/var_vg1

  if (ncp==0 & is.null(hsq0) & is.null(var_vg0)) {
  l$ncp0 <- 0
  } else { 
  l$ncp0 <- hsq0^2/var_vg0;
  }
  
  l$power <- power_func(l$ncp1, l$ncp0, alpha)
  return(l)
}




# --------------------------------------------------
# Function for case-control study
# ncase = number of cases
# ncontrol = number of controls
# K = disease prevalence in the population
calcUniCc <- function(
    ncase  = 1000,
    ncontrol = 1000,
    hsq = 0.5,
    K = 0.1,
    alpha = 0.05,
    var_pi=2e-5
){
  h <- h2O_func(ncase, ncontrol, K, hsq, var_pi)
  l <- list()
  l$se <- sqrt(h$var_h2L)
  l$ncp <- h$h2L^2/h$var_h2L
  l$power <- power_func(l$ncp, alpha)
  return(l)
}


# --------------------------------------------------
# Function for bivariate analysis of two quantitative traits
# rg = genetic correlation
# rp = phenotypic correlation
# overlap = whether or not the traits are measured on the same samples
calcBiQt <- function(
    n1 = 1000,
    n2 = 1000,
    hsq1 = 0.5,
    hsq2 = 0.5,
    rg = 0.5,
    rp = 0.5,
    overlap = FALSE,
    alpha  = 0.05,
    var_pi=2e-5
){
  var_rg <- var_rg_func(n1, n2, hsq1, hsq2, rg, rp, overlap, var_pi)
  l <- list()
  l$se <- sqrt(var_rg)
  l$ncp <- rg^2/var_rg;
  l$power <- power_func(l$ncp, alpha)
  return(l)
}


# --------------------------------------------------
# Function for bivariate analysis of two case-control studies
calcBiCc <- function(
    ncase1 = 1000,
    ncase2 = 1000,
    ncontrol1 = 1000,
    ncontrol2 = 1000,
    hsq1 = 0.5,
    hsq2 = 0.5,
    K1 = 0.1,
    K2 = 0.1,
    rg = 0.5,
    overlap  = FALSE,
    alpha = 0.05,
    var_pi=2e-5
){
  h1 <- h2O_func(ncase1, ncontrol1, K1, hsq1, var_pi)
  h2 <- h2O_func(ncase2, ncontrol2, K2, hsq2, var_pi)
  n1 <- ncase1+ncontrol1
  n2 <- ncase2+ncontrol2
  var_rg <- var_rg_func(n1, n2, h1$h2O, h2$h2O, rg, rg, overlap, var_pi)
  l <- list()
  l$se <- sqrt(var_rg)
  l$ncp <- rg^2/var_rg;
  l$power <- power_func(l$ncp, alpha)
  return(l)
}


# Function for bivariate analysis of a quantitative trait and a binary trait (case-control study)
calcBiQtCc <- function(
    n = 1000,
    ncase = 1000,
    ncontrol = 1000,
    hsq1  = 0.5,
    hsq2  = 0.5,
    K = 0.1,
    rg  = 0.5,
    overlap = FALSE,
    alpha = 0.05,
    var_pi=2e-5
){
  h2=h2O_func(ncase, ncontrol, K, hsq2, var_pi)
  n2=ncase+ncontrol
  var_rg=var_rg_func(n, n2, hsq1, h2$h2O, rg, rg, overlap, var_pi)
  l <- list()
  l$se <- sqrt(var_rg)
  l$ncp <- rg^2/var_rg;
  l$power <- power_func(l$ncp, alpha)
  return(l)
}

###############################################################################
# Functions used in the functions above
var_vg_func <- function(N, var_pi=2e-5){
  return(2/(N^2*var_pi))
}

#sid.="20116_0_f"


# NOOOOOO
#var_vg_func_gral <- function(sid., var_pi.){
## if Qt
#if ( is.na(filter(metadata, sid==sid.)$Ncase) ) {
# val <- var_vg_func(N=filter(metadata, sid==sid.)$N, var_pi=var_pi.)
#} else { # if Qt (Bin)
#h <- h2O_func(ncase=filter(metadata, sid==sid.)$Ncase, 
#	      ncontrol=filter(metadata, sid==sid.)$Ncontrol,
#              K=filter(metadata, sid==sid.)$pop_prev, 
#              h2L=filter(metadata, sid=="20116_0_f")$SNPh2_l, 
#              var_pi=var_pi.)
#val <- h$var_h2O
#}
#return(val)
#}



# after calculating 
# metadata$var_vg <- sapply(metadata$sid, function(s) { var_vg_func_gral(sid.=s, var_pi.=2e-5)} )

ncp <- function(sid.) {
# if  Qt
if ( is.na(filter(metadata, sid==sid.)$Ncase) ) {
  #ncp <- hsq^2/var_vg
  #ncp <- filter(metadata, sid==sid.)$SNPh2^2/var_vg_func_gral(sid.="20116_0_f", var_pi.=2e-5)
  ncp <- filter(metadata, sid==sid.)$SNPh2^2/filter(metadata, sid==sid.)$var_vg
} else { # if Bin
  #ncp <- filter(metadata, sid==sid.)$SNPh2_l^2/var_vg_func_gral(sid.="20116_0_f", var_pi.=2e-5) 
   ncp <- filter(metadata, sid==sid.)$SNPh2_l^2/filter(metadata, sid==sid.)$var_vg

}
return(ncp)
}

# then run
# metadata$ncp <- sapply(metadata$sid, function(s) { ncp(sid.=s)} )
 







# Biv

var_rg_func <- function(N1, N2, hsq1, hsq2, rg, rp, overlap=TRUE, var_pi=2e-5){
  if(overlap==T) var_rg=((1-rg*rp)^2+(rg-rp)^2)/(hsq1*hsq2*N1^2*var_pi)
  if(overlap==F) var_rg=(rg^2*(N1^2*hsq1^2+N2^2*hsq2^2)+2*hsq1*hsq2*N1*N2)/(2*hsq1^2*hsq2^2*N1^2*N2^2*var_pi)
  return(var_rg)
}




power_func <- function(ncp1, ncp0, alpha){
if (ncp1 > ncp0) {
pchisq(qchisq(p=alpha, ncp=ncp0, df=1,lower.tail=F), ncp=ncp1, df=1, lower.tail=F)
} else {
pchisq(qchisq(p=alpha, ncp=ncp1, df=1,lower.tail=F), ncp=ncp0, df=1, lower.tail=F)
}
}




# run for difference from 0 given the estimates
# metadata$power <- sapply(metadata$sid, function(s) { power_func(ncp1=filter(metadata, sid==s)$ncp, ncp0=0, alpha=0.05)} )
# run for difference from the other sex (run for females)
metadata$power_diff <- sapply(metadata$sid, function(s) { 
				as.numeric(
                                 power_func(
                                 filter(metadata, phenotype==filter(metadata, sid==s)$phenotype, sex=="female")$ncp,
			         filter(metadata, phenotype==filter(metadata, sid==s)$phenotype, sex=="male")$ncp, 
                                  alpha=0.05)
                                  ) })

# diff size in obs scale
metadata$diff <- sapply(metadata$sid, function(s) { 
                                as.numeric(
 				abs(filter(metadata, phenotype==filter(metadata, sid==s)$phenotype, 
      sex=="female")$SNPh2 -filter(metadata, phenotype==filter(metadata, sid==s)$phenotype, sex=="male")$SNPh2)
)
}
)



h2O_func <- function(ncase, ncontrol, K, h2L, var_pi=2e-5){
  n=ncase+ncontrol
  v=ncase/(ncase+ncontrol)
  z=dnorm(qnorm(K))
  c=(K*(1-K))^2/(v*(1-v)*z^2)
  h2O=h2L/c
  var_h2O=var_vg_func(n, var_pi)
  var_h2L=c^2*var_h2O
  return(list(h2L=h2L, var_h2L=var_h2L, h2O=h2O, var_h2O=var_h2O))
}
###############################################################################



