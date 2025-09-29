#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory
  
  #RES_LIST=($(ls ../../../2-compare-m-f/real/outputs/*/m_f.txt)) 

  RES_LIST=$(ls ../../../2-analyze/real/outputs/*.sex_diff)

rm -rf ./real/inputs/joblist.txt
for RES in ${RES_LIST[@]}
do
echo $(basename  ${RES}  | cut -d '.' -f1) ${RES} EUR >> ./real/inputs/joblist.txt
done
 
  JOBLIST=./real/inputs/joblist.txt
  OUTPUT_DIR=./real/outputs
 
  
  # COMMAND
  COMMAND=" \
    ./real/scripts/jobs.sh \
      ${JOBLIST} \
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

