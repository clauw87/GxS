#!/bin/bash

# Main Code --------------------------------------------------------

main(){


  rm -rf ./real/outputs/*


  # Configuration
    
  
  CODEPAIRS_FILE=./real/inputs/paircodes.txt
  OUTPUTS_DIR='./real/outputs' 
  INPUTS_DIR='../01-format/test/outputs'
  SUFFIX='.formatted.sumstats.gz'  
  
  # COMMAND
  COMMAND=" \
    ./real/scripts/miami.sh \
      ${INPUTS_DIR} \
      ${CODEPAIRS_FILE} \
      ${OUTPUTS_DIR} \
      ${SUFFIX}
  "
  


  # Cluster array execution
  JOBS_COUNT=$(cat ${CODEPAIRS_FILE} | wc -l)
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

main
