#!/bin/bash
#


# Main Code --------------------------------------------------------
# Runs 

main(){

  # Creates and cleans directory structure
 # clean_directory

  # Configuration
  
  ls -d ../1a-munge/real/outputs/* | grep gz  | grep ADr1su > ./real/inputs/munged-sumstats.list

  #ls -d ../1a-munge/real/outputs/* | grep gz  |  grep peg >> ./real/inputs/munged-sumstats.list

  #ls -d ../1a-munge/real/outputs/* | grep gz  |  grep 110 >> ./real/inputs/munged-sumstats.list
  #ls -d ../1b-munge-assoc-in-A1/real/outputs/* | grep gz >> ./real/inputs/munged-sumstats.list 
  
  SUMSTATS_LIST=./real/inputs/munged-sumstats.list
  


  # Configuration  
  LDSC_OUTPUT_DIR=./real/outputs
  EUR_REFERENCE=./real/inputs/eur_w_ld_chr/




  # Runs
  COMMAND=" \
    ./real/scripts/LDSCh2.sh \
         ${SUMSTATS_LIST} \
         ${LDSC_OUTPUT_DIR} \
         ${EUR_REFERENCE} \         
  "
  
  # Execution      
  # Cluster execution
  JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)
  sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit

  # Direct execution
  bash ${COMMAND}
  exit 

} 







# FUNCTIONS ==========================================================


clean_directory(){
  # Creates and cleans directory structure
  
  if [ ! -d "real" ]; then

    mkdir real
    mkdir real/scripts
    mkdir real/inputs
    mkdir real/tmp
    mkdir real/outputs

  else

    if [ ! -d "real/scripts" ]; then
  mkdir real/scripts
    fi

    if [ ! -d "real/inputs" ]; then
  mkdir real/inputs
    fi

    if [ ! -d "real/tmp" ]; then
  mkdir real/tmp
    else
  rm -fR real/tmp/*
    fi

    if [ ! -d "real/outputs" ]; then
  mkdir real/outputs
    else
  rm -fR real/outputs/*
    fi

  fi
}
 
 
main



