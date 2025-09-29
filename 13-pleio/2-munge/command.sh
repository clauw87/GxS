#!/bin/bash

# Main Code --------------------------------------------------------
# Runs pleioFDR pairwise between a reference trait and a list of traits

main(){

  # Creates and cleans directory structure
  clean_directory


  # Configuration

# make inputs    

  ls -d ../1-format/real/outputs/* | grep gz  > ./real/inputs/formatted.list
  #ls -d ../1-format/real/outputs/* | grep gz | grep a9f >> ./real/inputs/formatted.list  
  
  SUMSTATS_LIST=./real/inputs/formatted.list
  OUTPUTDIR=./real/outputs
  

  # Runs munge 
  COMMAND=" \
    ./real/scripts/pleio-munge.sh \
        ${SUMSTATS_LIST} \
        ${OUTPUTDIR}
  "




  JOBS_COUNT=$(cat "${SUMSTATS_LIST}" | wc -l)
  sbatch \
    --array=1-${JOBS_COUNT} \
    ${COMMAND}
  exit



  # Execution
  # Direct execution
  bash ${COMMAND}
  exit



  # Cluster execution
  sbatch ${COMMAND}
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
