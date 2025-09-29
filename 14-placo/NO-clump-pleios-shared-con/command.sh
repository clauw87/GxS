#!/bin/bash

# Main Code --------------------------------------------------------

main(){

  #rm -rf ./real/tmp/*
  rm -rf ./real/outputs/*
 
  
  ls ../1-run-placo/real/outputs/*.placo > ./real/inputs/placo.results
  
  RESLS=./real/inputs/placo.results
  TMPS_DIR=./real/tmp
  TARGET=con


  # change colnames remove dots, save to tmp as gz
  
  #rm -rf ./real/inputs/clump.list

  COMMAND0="./real/scripts/cut.sh ${RESLS} ${TARGET} ${TMPS_DIR}"
 

  #JOB0_COUNT=$(cat ${RESLS} | wc -l)
  #JOB0_ID=$(sbatch --parsable --array=1-${JOB0_COUNT} ${COMMAND0})


  JOIN="./real/scripts/list.sh ${TMPS_DIR}"
  #JOIN_ID=$(sbatch --parsable --dependency=afterany:${JOB0_ID} ${JOIN})
  #JOIN_ID=$(sbatch --parsable $JOIN)

  

  SUMSTATS_LIST=./real/inputs/clump.list
  MUNGED_DIR=../0-munge/real/outputs
  
  POPULATION=EUR
  REFERENCE_FOLDER="../../../../reference/1000G/${POPULATION}/1000G_Phase3_${POPULATION}_plink"


  OUTPUTS_DIR=./real/outputs
  


  SIG_LEVEL=0.00000005
  #SIG_LEVEL=0.000001
  
  # COMMAND
  COMMAND1=" \
    ./real/scripts/sumstatspy.clump.sh \
      ${SUMSTATS_LIST} \
      ${TMPS_DIR} \
      ${MUNGED_DIR} \
      ${REFERENCE_FOLDER} \
      ${POPULATION} \
      ${OUTPUTS_DIR} \
      ${SIG_LEVEL}
  "
  
  # Execution 

  # Cluster array execution
  JOBS_COUNT=$(cat ${RESLS} | wc -l)
  #sbatch --dependency=afterany:${JOIN_ID} --array=1-${JOBS_COUNT} ${COMMAND1}
  sbatch --array=1-${JOBS_COUNT} ${COMMAND1}

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
