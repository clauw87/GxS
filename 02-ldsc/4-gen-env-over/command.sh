#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory
  


  # Configuration
  ls -d ../3-rg/real/outputs/*.log  > ./real/inputs/rg.logs.list

  #exit


  JOBS_LIST=./real/inputs/rg.logs.list
  TMP_DIR=./real/tmp
  OUTPUT_DIR=./real/outputs
  

  # COMMAND
  COMMAND=" \
    ./real/scripts/env_covar.sh \
        ${JOBS_LIST} \
        ${OUTPUT_DIR} \
  "
          
  # Execution 
  # Cluster execution
  JOBS_COUNT=$(cat "${JOBS_LIST}" | wc -l)
  sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit

  # Job 2, join - after OK all the above


  # Job 3 env covariance and sample overlap on joined result



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
  mkdir real/scrips
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
