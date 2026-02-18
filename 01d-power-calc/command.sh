#!/bin/bash

# Main Code --------------------------------------------------------

main(){

  rm -rf real/outputs/*

  H2=/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/02-ldsc/2-join_h2_results/real/outputs/h2.txt
  
  POWERED="/data/samanthafs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt"

  # Configuration
  META_FILE=/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains_updated.txt
  #ls ../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt > ./real/inputs/metadata.list
   cat ${META_FILE} | head -n1 > ./real/inputs/metadata_target.txt
   cat ${META_FILE} | grep -w -f ${POWERED} >> ./real/inputs/metadata_target.txt

  ls ./real/inputs/metadata_target.txt > /gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01d-power-calc/real/inputs/metadata.list

  #ls ./real/inputs/metadata.txt > ./real/inputs/metadata.list

#exit

  METADATA_LIST=/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01d-power-calc/real/inputs/metadata.list
  OUTPUTS_DIR=/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01d-power-calc/real/outputs


  # COMMAND
  COMMAND=" \
    /gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01d-power-calc/real/scripts/run.sh \
      ${H2} \
      ${METADATA_LIST} \
      ${OUTPUTS_DIR} \
  "

  # Execution
  #rm -fR ./gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas_new/01d-power-calc/real/outputs/*

  # Cluster array execution
  JOBS_COUNT=$(cat ${METADATA_LIST} | wc -l)
  eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit

  sbatch ${COMMAND}
  exit

  # Direct execution
  # eval bash ${COMMAND}
  # exit

  # Cluster execution
  #eval sbatch ${COMMAND}
  #exit             

} 


# FUNCTIONS ==========================================================

main
