#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory


  ls -d ../1a-munge/real/outputs/* | grep munged > ./real/inputs/sumstats.list 
  #ls -d ../1b-munge-assoc-in-A1/real/outputs/* | grep munged >> ./real/inputs/sumstats.list 
  
  # Job configuration
  COMMAND="
          bash ./real/scripts/run.sh 
          "
  JOB_NAME="count_snps"
  
  # Direct Execution Cluster UPF
  module purge
  for MODULE in ${MODULES}; do module load ${MODULE}; done
  eval ${COMMAND}
  exit

  # Launches job at Cluster UPF
  module purge
  launch  \
      --output-directory ./real/outputs \
      --name ${JOB_NAME} \
      --modules " ${MODULES} " \
      --tasks 1*1 \
      --limit 02:00:00 \
      -c "${COMMAND}"
      
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
