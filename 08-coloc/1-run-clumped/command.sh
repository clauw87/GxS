#!/bin/bash

# Main Code --------------------------------------------------------

if [ ! -f "./command.sh" ]; then
      cp /homes/users/cvasallo/command.sh ./
fi


main(){


  # Creates and cleans directory structure
  clean_directory

  #cat /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/3-clump-to-count/real/outputs/*/*.zscore-result.clumped | grep DISCO | cut -f1 > ./real/inputs/disco.shared.indep.loci
  #cat /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/3-clump-to-count/real/outputs/a29m_a8m:a29f_a8f/a29m_a8m:a29f_a8f.result.clump.loci.csv | grep rs4267006

  
 
  # Configuration
  INPUTS_DIR=../0-munge/real/outputs
  SUFFIX='.coloc-munged-sumstats.gz'
  
  OUTPUTS_DIR=./real/outputs
  TMPS_DIR=real/tmp


  LOCI_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/3-clump-pleios/real/outputs

 
  ls -d ${LOCI_DIR}/*/*.result.clump.lead.csv  > ./real/inputs/indep.loci

   # NO ls -d ${LOCI_DIR}/*/*.result.clump.indep.csv  > ./real/inputs/indep.loci
  

   #cat ./real/inputs/indep.loci | grep -f todo.codes > ./real/inputs/indep.loci_more
   #INPUT_LIST=./real/inputs/indep.loci_more


   INPUT_LIST=./real/inputs/indep.loci
  

  COMMAND=" \
    ./real/scripts/run_coloc.sh \
	${INPUT_LIST} \
        ${INPUTS_DIR} \
        ${SUFFIX} \
	${OUTPUTS_DIR} \
        ${TMPS_DIR}
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




  
