#!/bin/bash

# Main Code --------------------------------------------------------
# Runs PLEIO preprocessing step and the PLEIO 
main(){

  # Creates and cleans directory structure
  clean_directory


  # Configuration
  OUTPUT_DIR=./real/outputs


# make inputs    
  
  ls ../3-preprocess/real/outputs/log.* | grep out | grep -v err | grep -v messages > ./real/tmp/logs.txt

  LOGS=./real/tmp/logs.txt

  COMMAND1=" \
    ./real/scripts/get_from_log.sh ${LOGS} ${OUTPUT_DIR} \
  "


  JOBS_COUNT=$(cat ${LOGS} | wc -l)
  sbatch \
    --array=1-${JOBS_COUNT} \
    ${COMMAND1}
  exit



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
