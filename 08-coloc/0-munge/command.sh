#!/bin/bash

# Main Code --------------------------------------------------------

main(){

  #rm -rf real/outputs/*
 

  # Configuration

  FORMAT_TYPE='coloc'


  
  # if re-formatted already, then just munge
  #find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/1-mr-format/test/outputs/) -iname *.${FORMAT_TYPE}-formatted-sumstats.gz | grep a28m > ./real/inputs/sumstats.list


  # gral format
  find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/real/outputs/) -iname *.formatted.sumstats.gz  | grep 128m  > real/inputs/formatted.list
  


  #find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/real/outputs/) -iname *.formatted.sumstats.gz | grep bm >> real/inputs/formatted.list.new
 

  SUMSTATS_LIST=real/inputs/formatted.list 

  SUFFIX='.formatted.sumstats.gz'

  OUTPUT_DIR=./real/outputs_gwama


  

  
  # COMMAND
  COMMAND=" \
    ./real/scripts/reformat.sh \
      ${SUMSTATS_LIST} \
      ${SUFFIX} \
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
