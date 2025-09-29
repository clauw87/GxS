#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory
  
  
  # Configuration
  # manually created job list
  JOBLIST=./real/inputs/jobList1.txt
  RES_FOLDER=real/inputs/genesets
  OUTPUT_DIR=./real/outputs
  METHOD=age

 
#exit
  # COMMAND
  COMMAND=" \
    ./real/scripts/jobs.sh \
      ${JOBLIST} \
      ${RES_FOLDER} \
      ${OUTPUT_DIR} \
      ${METHOD}
  "
  
 

  # Execution 
  # Cluster array execution
  JOBS_COUNT=$(cat ${JOBLIST} | wc -l)
  eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit

  # Direct execution
  #eval bash ${COMMAND}
  #exit 

  # Cluster execution
  #eval sbatch ${COMMAND}
  #exit             

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
