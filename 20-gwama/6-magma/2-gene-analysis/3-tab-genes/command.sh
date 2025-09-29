#!/bin/bash

# Main Code --------------------------------------------------------

if [ ! -f "./command.sh" ]; then
      cp /homes/users/cvasallo/command.sh ./
fi


main(){


  # Creates and cleans directory structure
  clean_directory
  


  # Configuration

  ls ../2-gene-analysis/real/outputs/*.gene.analysis.genes.out > ./real/inputs/res.files


  INPUT_LIST=./real/inputs/res.files


  OUTPUTS_DIR=./real/outputs

      
 

  COMMAND=" \
    ./real/scripts/run_tab_sig.sh \
	${INPUT_LIST} \
	${OUTPUTS_DIR} \
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




  
