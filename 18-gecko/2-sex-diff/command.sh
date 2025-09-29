#!/bin/bash

# Main Code --------------------------------------------------------

if [ ! -f "./command.sh" ]; then
      cp /homes/users/cvasallo/command.sh ./
fi


main(){


  # Creates and cleans directory structure
  clean_directory
  


  # Configuration
  INPUTS_DIR=./real/inputs


  cat ../1-run/real/outputs/*.gen_corr | head -n1 > ./real/inputs/rg.joined
  cat ../1-run/real/outputs/*.gen_corr | grep -v -w pair >> ./real/inputs/rg.joined   

  
  TMP_DIR=./real/tmp

    
 

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




  
