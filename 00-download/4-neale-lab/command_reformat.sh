#!/bin/bash


# Main Code --------------------------------------------------------
# Runs 

main(){
  
  # Creates and cleans directory structure
  #clean_directory 
  #rm -fR real/outputs2/*

  # Configuration
  
  # target list: all donloaded sumstats in real/output
  ls ./real/outputs/*.gz  > ./real/inputs/sumstats.list
       
  SUMSTATS_LIST=./real/inputs/sumstats.list 

  #VARIANTS_FILE=./real/inputs/variants.tsv.bgz
  VARIANTS_FILE=./real/inputs/variants-short.tsv.gz
  OUTPUTS_DIR=./real/outputs

#exit

  COMMAND=" \
    ./real/scripts/reformat.sh \
	${SUMSTATS_LIST} \
	${VARIANTS_FILE} \
        ${OUTPUTS_DIR}
         "



  # Execution
  # Cluster execution
  JOBS_COUNT=$(cat ./real/inputs/sumstats.list | wc -l)
  sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit

  # Direct execution
  bash ${COMMAND}
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
