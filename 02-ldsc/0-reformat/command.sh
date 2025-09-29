#!/bin/bash

# Main Code --------------------------------------------------------

main(){

  #rm -rf real/outputs/* 

  # Configuration
  FORMAT_TYPE='ldsc'
  
  find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/test/outputs/) -iname '*.formatted.sumstats.gz'  | grep ADr1su  > ./real/inputs/inter.list
 # find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/test/outputs/) -iname '*.formatted.sumstats.gz'  | grep 4213f  >> ./real/inputs/inter.list 
  #find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/test/outputs/) -iname '*.formatted.sumstats.gz'  | grep peg >> ./real/inputs/inter.list

  #find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/test/outputs/) -iname '*.formatted.sumstats.gz'  | grep 107 >> ./real/inputs/inter.list
  #find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/test/outputs/) -iname '*.formatted.sumstats.gz'  | grep 110 >> ./real/inputs/inter.list

  #find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/real/outputs/) -iname '*.formatted.sumstats.gz'  | grep ef >> ./real/inputs/inter.list

  # new ones - AD GRACE and brain measurements
  #find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/real/outputs/) -iname '*.formatted.sumstats.gz' | grep ag  > ./real/inputs/inter.list
  #find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/real/outputs/) -iname '*.formatted.sumstats.gz' | grep bm  >> ./real/inputs/inter.list
   

  #cat real/inputs/inter.list  | head -n1  > ./real/inputs/inter.list1
 
#exit
  
  SUMSTATS_LIST=./real/inputs/inter.list


  OUTPUT_DIR=./real/outputs


  

  
  # COMMAND
  COMMAND=" \
    ./real/scripts/reformat.sh \
      ${SUMSTATS_LIST} \
      ${FORMAT_TYPE} \
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
