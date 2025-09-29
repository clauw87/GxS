#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory

  cat ../3-rg/real/tmp/phenoscomballmin_minuselenas | cut -d ' ' -f1 | xargs -I {} basename {} | cut -d'.' -f1 > ./real/tmp/rg_trait1
  cat ../3-rg/real/tmp/phenoscomballmin_minuselenas | cut -d ' ' -f2 | xargs -I {} basename {} | cut -d'.' -f1 > ./real/tmp/rg_trait2
   
  CT_PAIRS=../../14-placo/1-run-placo/real/tmp/combipairs


  # Configuration
  GR_OUTPUTS_FOLDER=../3-rg/real/outputs

  # COMMAND
  COMMAND=" \
    ./real/scripts/run.sh \
        ${GR_OUTPUTS_FOLDER} \
  "
          
  # Execution 
  # Cluster execution
  #JOBS_COUNT=$(cat "${FORMATTED_SUMSTATS_LIST}" | wc -l)
  #sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  #exit
   
  sbatch ${COMMAND}
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
