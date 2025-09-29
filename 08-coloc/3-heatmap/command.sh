#!/bin/bash

# Main Code --------------------------------------------------------

if [ ! -f "./command.sh" ]; then
      cp /homes/users/cvasallo/command.sh ./
fi

main(){

  # Creates and cleans directory structure
  clean_directory
    
  # Configuration
  RES_FILE=../2-characterize-convincing/real/outputs/merge.mf.tot_shared_con_dis.txt
 
  INPUTS_LIST=./real/inputs/options
  OUTPUTS_DIR=./real/outputs

  COMMAND=" \
    ./real/scripts/run_heatmap.sh \
	${INPUTS_LIST} \
        ${RES_FILE} \
	${OUTPUTS_DIR} \
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




  
