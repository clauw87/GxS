#!/bin/bash

# Main Code --------------------------------------------------------
# Runs PLEIO preprocessing step and the PLEIO 
main(){


  # Creates and cleans directory structure
  #clean_directory


  # Configuration

# make inputs    
   
  rm -rf ./real/inputs/input_list.txt
     
  #list=$(ls -d ../4-clump-fuma-suggestive/real/outputs/*/result.clump.loci.csv)
  
  list=$(ls -d ../2-compare-m-f/real/outputs/*/shared_pleios_dis.txt )
  for l in $list
  do
     #basename $l >>  ./real/inputs/input_list.txt
  ls $l | cut -d '/' -f5 >>  ./real/inputs/input_list.txt
  done


  cat real/inputs/input_list.txt  | grep a7m | grep r10m > real/inputs/input_list1.txt


  INPUT_LIST=real/inputs/input_list1.txt

  

  INPUTS_DIR=../2-compare-m-f/real/outputs
  OUTPUTS_DIR=./real/outputs


  COMMAND=" \
    ./real/scripts/run_LDlinkR.sh \
	${INPUT_LIST} \
	${INPUTS_DIR} \
	${OUTPUTS_DIR}
  "


  #Cluster execution no array (LDlinkR cannot be queried in batch)
  
  sbatch ${COMMAND}

  exit
  
  #JOBS_COUNT=$(cat "${INPUT_LIST}" | wc -l)
  #sbatch \
  #  --array=1-${JOBS_COUNT} \
  #  ${COMMAND}
  #exit



  # Execution
  # Direct execution
  #bash ${COMMAND}
  #exit



  # Cluster execution
  #JOB1_ID=$(sbatch ${COMMAND})
  #exit

  # Cluster after OK
  #sbatch \
  #  --dependency=afterok:${JOB1_ID} \
  #  ${COMMAND2}
  #exit


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
