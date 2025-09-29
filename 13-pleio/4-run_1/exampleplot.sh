#!/bin/bash

# Main Code --------------------------------------------------------
# Runs PLEIO preprocessing step and the PLEIO 
main(){

  # Creates and cleans directory structure
  #clean_directory


  # Configuration

# make inputs    
 
  
  OUTPUT_DIR=./test/outputs

  COMMAND=" \
    ./test/scripts/pleioplot.sh ./test/input_directory \
  "



  #JOBS_COUNT=$(cat "${INPUT_LIST}" | wc -l)
  #sbatch \
  #  --array=1-${JOBS_COUNT} \
  #  ${COMMAND}
  #exit



  # Execution
  # Direct execution
  #bash ${COMMAND}
  #exit



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

  if [ ! -d "test" ]; then

    mkdir test
    mkdir test/scripts
    mkdir test/inputs
    mkdir test/tmp
    mkdir test/outputs

  else

    if [ ! -d "test/scripts" ]; then
  mkdir test/scripts
    fi

    if [ ! -d "test/inputs" ]; then
  mkdir test/inputs
    fi

    if [ ! -d "test/tmp" ]; then
  mkdir test/tmp
    else
  rm -fR test/tmp/*
    fi

    if [ ! -d "test/outputs" ]; then
  mkdir test/outputs
    else
  rm -fR test/outputs/*
    fi

  fi
}


main
