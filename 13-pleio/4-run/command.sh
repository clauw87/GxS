#!/bin/bash

# Main Code --------------------------------------------------------
# Runs PLEIO preprocessing step and the PLEIO 
main(){



#exit

  # Creates and cleans directory structure
  clean_directory


  # Configuration

# make inputs    
   
  rm ./real/inputs/input_list.txt
     
  list=$(ls -d ../3-preprocess/real/outputs/*/)

  for l in $list
  do
     basename $l >>  ./real/inputs/input_list.txt
  done

  INPUT_LIST=real/inputs/input_list.txt

  
  # doing the failed ones only 
  #cat real/inputs/input_list.txt | grep -f error > ./real/inputs/failed_list.txt
  #INPUT_LIST=./real/inputs/failed_list.txt
  # just 276 now failed
  #cat real/inputs/input_list.txt |  grep -f error2  > ./real/inputs/failed_list276.txt
  #INPUT_LIST=./real/inputs/failed_list276.txt


  OUTPUT_DIR=./real/outputs


  COMMAND=" \
    ./real/scripts/pleio.sh \
    ${INPUT_LIST} \
    ${OUTPUT_DIR} \
  "



  JOBS_COUNT=$(cat "${INPUT_LIST}" | wc -l)
  sbatch \
    --array=1-${JOBS_COUNT} \
    ${COMMAND}
  exit



  # Execution
  # Direct execution
  bash ${COMMAND}
  exit



  # Cluster execution
  JOB1_ID=$(sbatch ${COMMAND})
  exit

  # Cluster after OK
  sbatch \
    --dependency=afterok:${JOB1_ID} \
    ${COMMAND2}
  exit


  # Cluster execution - array
   JOBS_COUNT=$(cat "${SUMSTATS_LIST}" | wc -l)
  sbatch \
    --dependency=afterok:${JOB_ID} \
    --array=1-${JOBS_COUNT} \
    ${COMMAND}
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
