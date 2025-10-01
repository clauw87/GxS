#!/bin/bash

# Main Code --------------------------------------------------------


main(){ 
  
  # Creates and cleans directory structure
  clean_directory
  
  # Configuration
  H2_OUTPUTS_FOLDER=../2-h2/real/outputs

  # COMMAND
  COMMAND=" \
    ./real/scripts/run.sh \
        ${H2_OUTPUTS_FOLDER} \
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
