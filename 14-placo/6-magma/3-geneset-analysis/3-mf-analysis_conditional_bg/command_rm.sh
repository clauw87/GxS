#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory
  
  

  POPULATION=EUR
  BDNAME=go_mf
  
  # Configuration
  # manually created joblist  
  ls ../../2-gene-analysis/2-gene-analysis/real/outputs/*.gene.analysis.genes.raw > ./real/inputs/jobList.txt
  
  #RESULTS_FOLDER=../../../2-compare-m-f/real/outputs
  RESULTS_FOLDER=../../2-gene-analysis/2-gene-analysis/real/outputs

  JOBLIST=./real/inputs/jobList.txt
  
  #CUSTOME_GENESETS=../1-create-inputs/real/inputs/genesets
  OUTPUT_DIR=./real/outputs
 

  # COMMAND
  COMMAND=" \
    ./real/scripts/jobs.sh \
      ${JOBLIST} \
      ${RESULTS_FOLDER} \
      ${OUTPUT_DIR} \
      ${BDNAME} \
      ${POPULATION}
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
