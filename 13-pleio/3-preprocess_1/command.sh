#!/bin/bash

# Main Code --------------------------------------------------------
# Runs PLEIO preprocessing step and the PLEIO 
main(){


#exit
  # Creates and cleans directory structure
  #clean_directory

   
  # Configuration
  RUN_NAME=r5m_a9m
  RUN_IDS=./real/inputs/${RUN_NAME}


  mkdir ./real/outputs/${RUN_NAME}

  # Inputs
  METADATA=../../3-power-calc/real/inputs/metadata.txt
 
# make inputs by grepping desired sids or a long sid list from file in the pleio munge outputs 
  ls -d ../2-munge/real/outputs/* | grep gz | grep -f ${RUN_IDS}  > ./real/inputs/formatted.list.${RUN_NAME}
  


  SUMSTATS_LIST=./real/inputs/formatted.list.${RUN_NAME}
  #SUFFIX='.pleio-formatted-sumstats.gz' 
  SUFFIX='.gz'


  module load R
  Rscript ./real/scripts/create_input_list.R $METADATA $SUMSTATS_LIST $SUFFIX $RUN_NAME


#exit
   
  INPUT_LIST=real/inputs/input_list_${RUN_NAME}.txt
  OUTPUT_DIR=./real/outputs/${RUN_NAME}



  # Runs PLEIO preprocess
  COMMAND=" \
    ./real/scripts/preprocess.sh \
        ${INPUT_LIST} \
        ${OUTPUT_DIR} \
  "



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
  sbatch ${COMMAND}
  
  exit


  #JOB1_ID=$(sbatch ${COMMAND})
  
#exit

# TODO: failed with the 2 subsequent jobs
  
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
