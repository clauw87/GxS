#!/bin/bash

# Main Code --------------------------------------------------------

main(){

 # Creates and cleans directory structure
 #clean_directory



  # Configuration
  RES_FILE=../3-join_rg_results/real/outputs/formatted_rg_res.txt
  #RES_FILE=../3-join_rg_results/real/outputs/formatted_rg_res_requested.txt
  META_FILE=../../00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains_updated.txt
  FIL=True # remove Bernabeu ones for rg1 -- , and Neales
  OUTPUTS_DIR=./real/outputs

  # COMMAND
  COMMAND=" \
    ./real/scripts/run.sh \
        ${RES_FILE} \
        ${META_FILE} \
        ${FIL} \
        ${OUTPUTS_DIR}
  "


  sbatch ${COMMAND}
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
