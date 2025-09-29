#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
   rm -fR ./real/outputs/*
   #rm -fR ./real/tmp/* 

  # Configuration
  
  #RESULTS_FOLDER=../3-run/real/outputs
  #find ${RESULTS_FOLDER} -name '*.gz'   | grep pleio  > ./real/inputs/sumstats.list
  #ls ../3-run/real/outputs/pleio.txt.gz > ./real/inputs/sumstats.list

  #ls real/tmp/pleio-res.gz > ./real/inputs/sumstats.list

  SUMSTATS_LIST=./real/inputs/sumstats.list

  REFERENCE_FOLDER=/gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/data/ref_1kG_phase3_EUR  
  REFERENCE_FOLDER=/gpfs42/projects/lab_anavarro/disease_pleiotropies/reference/1000G/EUR/1000G_Phase3_EUR_plink 
  OUTPUT_DIR=./real/outputs
  

  
  # COMMAND
  COMMAND=" \
    ./real/scripts/clump-results.sh \
      ${SUMSTATS_LIST} \
      ${REFERENCE_FOLDER} \
      ${OUTPUT_DIR}
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
