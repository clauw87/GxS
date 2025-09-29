#!/bin/bash

# Main Code --------------------------------------------------------
# Runs pleioFDR pairwise between a reference trait and a list of traits

main(){

  # Creates and cleans directory structure
  #clean_directory

  # powered 46 traits/diseases hachathon
  #cat /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/3-power-calc/real/outputs/metadata_power.txt | cut -f1 | tail -n +2 > real/inputs/46.txt

  # new powered excluding elena's
  cat /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt | grep -v 'ef_' | grep -v 'em_' > ./real/inputs/new_minuselena.txt
 
  # Configuration 
  #ls /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/real/outputs/*.gz | grep -f ./real/inputs/new_minuselena.txt > ./real/inputs/formatted.list
  ls /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/08-coloc/0-munge/real/outputs/*.gz | grep -f ./real/inputs/new_minuselena.txt > ./real/inputs/formatted.list
  

  SUMSTATS_LIST=./real/inputs/formatted.list
  TMP_DIR=./real/tmp
  OUTPUT_DIR=./real/outputs 

  # Creates Matlab Sumstats for all traits


  # Runs pleioFDR for all combinations of traits
  COMMAND=" \
    ./real/scripts/run-creatematlab.sh \
        ${SUMSTATS_LIST} \
        ${TMP_DIR} \
        ${OUTPUT_DIR} \
  "

# --dependency=afterok:${JOB_ID} \
  JOBS_COUNT=$(cat "${SUMSTATS_LIST}" | wc -l)
  sbatch \
    --array=1-${JOBS_COUNT} \
    ${COMMAND}
  exit

  # Execution
  # Direct execution
  bash ${COMMAND}
  exit

  # Cluster execution
  sbatch ${COMMAND}
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
