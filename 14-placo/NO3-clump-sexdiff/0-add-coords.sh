#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
   #rm -fR ./real/outputs/*
   #rm -fR ./real/tmp/* 
   #rm -fR real/inputs/*
  
# Configuration
# Merge with 1000G to restore BP and CHR columns,


# code or list of codes

# simple analysis
# readlink -f ../1-run-placo/real/outputs/*.placo > real/inputs/sumstats.list
# from one file two p columns
# readlink -f ../2-compare-m-f/real/outputs/*.m_f.full.txt


# sex differential analysis, to clump on sex diff snp
# shared gw level, 3630 SNPs
readlink -f ../2-compare-m-f/real/outputs/*.m_f.shared.5e-08.txt   > ./real/inputs/sumstats.list

# shared suggestive level 5276
#cat ../2-compare-m-f/real/outputs/*.m_f.shared.1e-06.txt | grep DISCORDANT | wc -l



SUMSTATS_LIST=./real/inputs/sumstats.list




#cat ${SUMSTATS_LIST} | xargs -I {} basename {} | sed s/'.placo'//g > ./real/inputs/input_list.txt
#INPUT_LIST=./real/inputs/input_list.txt

OUTPUTS_DIR=./real/tmp



COMMAND="./real/scripts/merge.sh ${SUMSTATS_LIST} ${OUTPUTS_DIR}"

  # Execution 
 

  # Cluster array execution
  JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)
  eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit

  # Direct execution
  #eval bash ${COMMAND}
  #exit 

  # Cluster execution
  #eval sbatch ${COMMAND}
  #exit             

} 


# FUNCTIONS ==========================================================

main
