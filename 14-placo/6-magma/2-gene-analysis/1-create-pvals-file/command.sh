#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory

  
  ls ../../../2-compare-m-f/real/outputs/*/m_f.txt  > ./real/inputs/jobList.txt

  #file=$(ls ../../../2-compare-m-f/real/outputs/*/m_f.txt | grep r5 | grep r9)
  #echo $(basename $file) $file EUR
  #echo $(echo $file | cut -d '/' -f7) $file EUR > ./real/inputs/jobList1.txt


  TMP_DIR=./real/tmp
  JOBLIST=./real/inputs/jobList.txt
  OUTPUT_DIR=./real/outputs
 
  
  # COMMAND
  COMMAND=" \
    ./real/scripts/jobs.sh \
      ${JOBLIST} \
      ${TMP_DIR} \
      ${OUTPUT_DIR}        
  "
  
  # Execution 
  # Cluster array execution
  JOBS_COUNT=$(cat ${JOBLIST} | wc -l)
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

