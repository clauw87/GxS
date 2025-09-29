#!/bin/bash

# Main Code --------------------------------------------------------

main(){

 rm -fR ./real/outputs/*

  # Configuration
   
  POWERED=../../02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt 

  #readlink -f ../1-calculate-bdiff/real/outputs/*.gz   > ./real/inputs/sumstats.list
  #ls ../2-analyze/real/outputs/*.sex_diff_5e-08  | grep -f ${POWERED} | grep -v em | grep -v ef  > ./real/inputs/res.list
  #ls ../2-analyze/real/outputs/*.sex_diff_v | grep -f ${POWERED} | grep -v em | grep -v ef  > ./real/inputs/res.list

  ls ../2-analyze/real/outputs/*.sex_diff_iii | grep -f ${POWERED} | grep -v em | grep -v ef > ./real/inputs/res.list_iii


  RESULTS_LIST=./real/inputs/res.list_iii


  #REFERENCE=../../01-format/real/inputs/1000G_Phase3_EUR.tsv.gz
  
  REFERENCE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/data/ref_1kG_phase3_EUR

  OUTPUT_DIR=./real/outputs
  
  
  # COMMAND
  COMMAND=" \
    ./real/scripts/clump-results.sh \
      ${RESULTS_LIST} \
      ${REFERENCE} \
      ${OUTPUT_DIR}
  "
  
  # Execution 
 

  # Cluster array execution
  JOBS_COUNT=$(cat ${RESULTS_LIST} | wc -l)
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
