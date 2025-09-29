#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  ls -d ../1-run/real/outputs/*.results > ./real/tmp/res.list

  RESULTS_LIST=./real/tmp/res.list
   
  OUTPUT_DIR=./real/outputs

 

  # COMMAND
  COMMAND1=" \
    ./real/scripts/lcv_res_format.sh \
      ${RESULTS_LIST} \
      ${OUTPUT_DIR}       
  "
  
  COMMAND2=" \
  ./real/scripts/joinres.sh
   "

 
  # Execution 
  # Cluster array execution
  JOBS_COUNT=$(cat ${RESULTS_LIST} | wc -l)

  #eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  
  JOB1_ID=$(sbatch --parsable --array=1-${JOBS_COUNT} ${COMMAND1})
  

  eval sbatch --dependency=afterany:${JOB1_ID} ${COMMAND2}



  #exit

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
