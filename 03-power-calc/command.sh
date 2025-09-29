#!/bin/bash

# Main Code --------------------------------------------------------

main(){

  # Configuration

  ls ../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt > ./real/inputs/metadata.list
  
  #ls ./real/inputs/metadata.txt > ./real/inputs/metadata.list

#exit
  
  METADATA_LIST=./real/inputs/metadata.list
  OUTPUTS_DIR=./real/outputs
   

  # COMMAND
  COMMAND=" \
    ./real/scripts/run.sh \
      ${METADATA_LIST} \
      ${OUTPUTS_DIR} \
  "
  
  # Execution 
  rm -fR ./real/outputs/*

  # Cluster array execution
  JOBS_COUNT=$(cat ${METADATA_LIST} | wc -l)
  eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit
  
  sbatch ${COMMAND}
  exit

  # Direct execution
  # eval bash ${COMMAND}
  # exit 

  # Cluster execution
  #eval sbatch ${COMMAND}
  #exit             

} 


# FUNCTIONS ==========================================================

main
