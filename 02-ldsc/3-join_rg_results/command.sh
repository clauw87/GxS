#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory
   

  # Configuration
  GR_OUTPUTS_FOLDER=../3-rg/real/outputs
  META_FILE=../00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains.txt
  POWERED_FILE=../2-join_h2_results/real/outputs/h2_powered_2.txt
  
  # COMMAND
  COMMAND=" \
    ./real/scripts/run.sh \
        ${GR_OUTPUTS_FOLDER} \
        ${META_FILE} \
        ${POWERED_FILE}
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
