#!/bin/bash

# Main Code --------------------------------------------------------
# Runs PLEIO preprocessing step and the PLEIO 
main(){


#exit
  # Creates and cleans directory structure
  clean_directory


  # create input
  ls ../2-munge/real/outputs/ | grep gz | cut -d '.' -f1 > ./real/inputs/munged.list
 
  # combine ids
  bash real/scripts/trait_combinations.sh ./real/inputs/munged.list ./real/tmp


  # testing
  #cat ./real/tmp/phenoscomb | head -n4 > ./real/tmp/phenoscomb_short
  #INPUTS_LIST=./real/tmp/phenoscomb_short
  

  INPUTS_LIST=./real/tmp/phenoscomb
  
  #cat ./real/tmp/phenoscomb | grep -f error3 > ./real/tmp/failed3

  #INPUTS_LIST=./real/tmp/failed3
  #INPUTS_LIST=failed1
  
  OUTPUT_DIR=./real/outputs


  # Runs PLEIO preprocess
  COMMAND=" \
    ./real/scripts/preprocess.sh \
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
  #bash ${COMMAND}
  #exit



  # Cluster execution
  sbatch ${COMMAND}  
  exit


  #JOB1_ID=$(sbatch ${COMMAND})
  
#exit

# TODO: failed with the 2 subsequent jobs
  
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
