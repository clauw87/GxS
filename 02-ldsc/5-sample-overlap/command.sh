#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory
  


  # Configuration
  RG_RES_FILE=./real/tmp/rg_res
  TMP_DIR=./real/tmp
  OUTPUT_DIR=./real/outputs
  
  COMMAND1="./real/scripts/rg_res_join.sh"

  # COMMAND2
  COMMAND2=" \
    ./real/scripts/sample_overlap.sh \
        ${RG_RES_FILE} \
        ${OUTPUT_DIR} \
  "
          
  # Execution 
  # Cluster execution
  #JOBS_COUNT=$(cat "${JOBS_LIST}" | wc -l)
  #sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  #exit

  # Job 2, sample overlap matrix



  # Direct execution
  JOB1_ID=$(sbatch ${COMMAND1})
  #exit 
   
  sbatch --dependency=afterok:${JOB1_ID} ${COMMAND2}
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
