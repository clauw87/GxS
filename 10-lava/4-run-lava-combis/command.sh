#!/bin/bash

# Main Code --------------------------------------------------------

#cp /homes/users/cvasallo/command.sh ./



main(){


  # Creates and cleans directory structure
  clean_directory

  POWERED=../../02-ldsc/2-join_h2_results/real/outputs/h2_powered_min.txt  

  cat ../../14-placo/1-run-placo/real/inputs/m.ids | grep -v -f ${POWERED} > ./real/inputs/rm_m.ids
  cat ../../14-placo/1-run-placo/real/inputs/f.ids | grep -v -f ${POWERED} > ./real/inputs/rm_f.ids

  rm_m_ids=./real/inputs/rm_m.ids
  rm_f_ids=./real/inputs/rm_f.ids

  UNIVARIATE_THR=0.0001  

  # Configuration
  
  cat ../../14-placo/1-run-placo/real/tmp/phenoscomballmin_minuselena | grep -f ../../14-placo/1-run-placo/real/tmp/f_phenoscomb | grep -v -f ${rm_f_ids} > ./real/inputs/fcombis.txt
  cat ../../14-placo/1-run-placo/real/tmp/phenoscomballmin_minuselena | grep -f ../../14-placo/1-run-placo/real/tmp/m_phenoscomb | grep -v -f ${rm_m_ids} > ./real/inputs/mcombis.txt


  PHENOS_DIR=./real/inputs
  INFO_FILE_DIR=../1-inputs/real/outputs
  SAMPLE_OVERLAP_DIR=../2-ldsc/3-sample_overlap/real/outputs
  LOC_FILE=../1-inputs/real/inputs/blocks_s2500_m25_f1_w200.locfile
  REF_PREFIX=../1-inputs/real/inputs/g1000_eur/g1000_eur
  OUTPUTS_DIR=./real/outputs    

  COMMAND_F=" \
    ./real/scripts/run_lava.sh \
        ${PHENOS_DIR}/fcombis.txt
	${INFO_FILE_DIR}/input.info_f.txt \
        ${SAMPLE_OVERLAP_DIR}/female.sample.overlap.txt \
	"F" \
        ${REF_PREFIX} \
        ${LOC_FILE} \
	${OUTPUTS_DIR} \
        ${UNIVARIATE_THR}
  "


  JOBS_COUNT_F=$(cat ${INPUT_FILE_DIR}/input.info_f.txt | wc -l)
  sbatch \
    --array=1-${JOBS_COUNT_F} \
    ${COMMAND_F}
 

  COMMAND_M=" \
    ./real/scripts/run_lava.sh \
        ${PHENOS_DIR}/mcombis.txt \
        ${INFO_FILE_DIR}/input.info_m.txt \
        ${SAMPLE_OVERLAP_DIR}/male.sample.overlap.txt \
        "M" \
        ${REF_PREFIX} \
        ${LOC_FILE} \
        ${OUTPUTS_DIR} \
        ${UNIVARIATE_THR}

  "


  JOBS_COUNT_M=$(cat ${INPUT_FILE_DIR}/input.info_m.txt | wc -l)
  sbatch \
    --array=1-${JOBS_COUNT_M} \
    ${COMMAND_M}

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




  
