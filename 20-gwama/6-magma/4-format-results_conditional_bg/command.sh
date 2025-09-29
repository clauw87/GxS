#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory
  
  #readlink -f ../3-genesets-analysis_conditional_bg/2-run-model/real/outputs/*.geneset.analysis.gsa.out   > ./real/inputs/jobList.txt
  
   readlink -f ../3-geneset-analysis/*/real/outputs/*.geneset.analysis.gsa.out > ./real/inputs/jobList.txt

  JOBSLIST=./real/inputs/jobList.txt
  OUTPUTS_DIR=./real/outputs
 
  
  # COMMAND
  COMMAND=" \
    ./real/scripts/jobs.sh \
      ${JOBSLIST} \
      ${OUTPUTS_DIR}        
  "
  
  # Execution 
  # Cluster array execution
  JOBS_COUNT=$(cat ${JOBSLIST} | wc -l)
  sbatch --array=1-${JOBS_COUNT} ${COMMAND}
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
  mkdir real/scrips
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

