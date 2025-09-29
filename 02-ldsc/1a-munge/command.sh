#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  #clean_directory
 
  # Configuration
  find $(readlink -f ../0-reformat/real/outputs/) -iname '*.gz'    | grep ADr1su > ./real/inputs/formatted-sumstats.list
  #find $(readlink -f ../0-reformat/real/outputs/) -iname '*.gz'    | grep ADr  >> ./real/inputs/formatted-sumstats.list

  #find $(readlink -f ../0-reformat/real/outputs/) -iname '*.gz'    | grep 107    >> ./real/inputs/formatted-sumstats.list
  #find $(readlink -f ../0-reformat/real/outputs/) -iname '*.gz'    | grep 110    >> ./real/inputs/formatted-sumstats.list

  

  FORMATTED_SUMSTATS_LIST=./real/inputs/formatted-sumstats.list  
  OUTPUT_DIR=./real/outputs
  REF_ALLELES=./real/inputs/w_hm3.snplist


  # COMMAND
  COMMAND=" \
    ./real/scripts/munge.sh \
        ${FORMATTED_SUMSTATS_LIST} \
        ${OUTPUT_DIR} \
        ${REF_ALLELES} \
  "
          
  # Execution 
  # Cluster execution
  JOBS_COUNT=$(cat "${FORMATTED_SUMSTATS_LIST}" | wc -l)
  sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit

  # Direct execution, first element test
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
