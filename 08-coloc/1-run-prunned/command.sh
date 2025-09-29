#!/bin/bash

# Main Code --------------------------------------------------------

if [ ! -f "./command.sh" ]; then
      cp /homes/users/cvasallo/command.sh ./
fi


main(){


  # Creates and cleans directory structure
  #clean_directory  
 
  # Configuration
  INPUTS_DIR=../0-munge/real/outputs
  SUFFIX='.coloc-munged-sumstats.gz'
  
  OUTPUTS_DIR=./real/outputs
  TMPS_DIR=real/tmp


  LOCI_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/4-prunning/real/outputs
 
  #INPUT_LIST=${LOCI_DIR}/shared.dis.gw.pruned

  #INPUT_LIST=${LOCI_DIR}/shared.dis.gw.loci
  #TYPE='dis'

  INPUT_LIST=${LOCI_DIR}/shared.con.gw.loci
  TYPE='con'

  COMMAND=" \
    ./real/scripts/run_coloc.sh \
	${INPUT_LIST} \
        ${INPUTS_DIR} \
        ${SUFFIX} \
	${OUTPUTS_DIR} \
        ${TMPS_DIR} \
        ${TYPE}
  "



  
 #JOBS_COUNT=$(cat "${INPUT_LIST}" | wc -l)
  JOBS_COUNT=$(cat "${INPUT_LIST}" | cut -f4 | grep -v pair | sort -u | wc -l) 
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




  
