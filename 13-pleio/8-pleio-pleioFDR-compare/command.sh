#!/bin/bash

# Main Code --------------------------------------------------------
# Runs PLEIO preprocessing step and the PLEIO 
main(){

  # Creates and cleans directory structure
  clean_directory

  # Configuration

# make inputs    
  
  # Inputs: a file with a list of codes as in pleioFDR/PLEIO that come from running the combination script, which should have been used as input list for PLEIO as well but didnt, so code and code_inv will be checked
  
  cat ../4-run/real/inputs/input_list.txt > ./real/inputs/input_list.txt  
  
  INPUTS_LIST=./real/inputs/input_list.txt

  #INPUTS_LIST=real/inputs/test.list.txt
  
  OUTPUT_DIR=./real/outputs


  COMMAND=" \
    ./real/scripts/compare.sh \
    ${INPUTS_LIST} \
    ${OUTPUT_DIR} \
  "



  JOBS_COUNT=$(cat "${INPUTS_LIST}" | wc -l)
  sbatch \
    --array=1-${JOBS_COUNT} \
    ${COMMAND}
  exit



  # Execution
  # Direct execution
  bash ${COMMAND}
  exit



  # Cluster execution
  JOB1_ID=$(sbatch ${COMMAND})
  exit

  # Cluster after OK
  sbatch \
    --dependency=afterok:${JOB1_ID} \
    ${COMMAND2}
  exit


  # Cluster execution - array
   JOBS_COUNT=$(cat "${SUMSTATS_LIST}" | wc -l)
  sbatch \
    --dependency=afterok:${JOB_ID} \
    --array=1-${JOBS_COUNT} \
    ${COMMAND}
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
