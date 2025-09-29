#!/bin/bash

# Main Code --------------------------------------------------------
# Runs pleioFDR pairwise between a reference trait and a list of traits

main(){

  # Creates and cleans directory structure
 #clean_directory
  


 
  # Configuration
  
  POWERED=../../02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt

  cat ../1-create-mat/real/inputs/formatted.list | grep -f ${POWERED} | grep -v em_ | grep -v ef_  > ./real/inputs/formatted.list


  SUMSTATS_LIST=./real/inputs/formatted.list
  OUTPUT_DIR=./real/outputs

  bash ./real/scripts/trait_combinations.sh ${SUMSTATS_LIST}

  COMBI_LIST=./real/inputs/phenoscomb 


  MAT_DIR=../1-create-mat/real/outputs


  # Runs pleioFDR for all combinations of traits
  COMMAND=" \
    ./real/scripts/run-pleioFDR_stepz.sh \
        ${COMBI_LIST} \
        ${MAT_DIR} \
        ${OUTPUT_DIR} \
  "



  JOBS_COUNT=$(cat "${COMBI_LIST}" | wc -l)
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
