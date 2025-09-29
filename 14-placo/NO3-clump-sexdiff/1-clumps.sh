#!/bin/bash

# Main Code --------------------------------------------------------

main(){

  rm -rf ./real/outputs/*

  
  #cat /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/1-run-placo/real/outputs > real/inputs/sumstats.list


  ls real/tmp/*.cut.txt.gz > ./real/inputs/clump.list


  SUMSTATS_LIST=./real/inputs/clump.list


  REFERENCE_FOLDER=/gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/data/ref_1kG_phase3_EUR
 
  OUTPUTS_DIR=./real/outputs
  TMPS_DIR=./real/tmp
  
  # COMMAND
  COMMAND=" \
    ./real/scripts/sumstatspy.clump.sh \
      ${SUMSTATS_LIST} \
      ${TMPS_DIR} \
      ${REFERENCE_FOLDER} \
      ${OUTPUTS_DIR}
  "
  
  # Execution 

  # Cluster array execution
  JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)
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

main
