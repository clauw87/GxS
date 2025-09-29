#!/bin/bash

# Main Code --------------------------------------------------------

cp /homes/users/cvasallo/command.sh ./

main(){


  # Creates and cleans directory structure
  clean_directory
  
  exit

  # Configuration

  ls ../1-run-placo/real/outputs/*.placo > ./real/inputs/placo.files


  INPUTS_DIR=./real/inputs
  TMP_DIR=./real/tmp

  # PAIRED UP PAIRS as sbatch input list
    
 

  COMMAND=" \
    ./real/scripts/run_placo.sh \
	${INPUT_LIST} \
	${MUNGE_DIR} \
	${OUTPUTS_DIR} \
        ${FILES_SUFFIX}
  "



  JOBS_COUNT=$(cat "${INPUT_LIST}" | wc -l)
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




  
