#!/bin/bash

# Main Code --------------------------------------------------------

main(){

  rm -rf real/outputs/* 

  # Configuration
  FORMAT_TYPE='ldsc'
  
  find $(readlink -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/test/outputs/) -iname '*.formatted.sumstats.gz'    > ./real/inputs/inter.list

  SUMSTATS_LIST=./real/inputs/inter.list

  OUTPUTS_DIR=./real/outputs

  
  # COMMAND
  COMMAND=" \
    ./real/scripts/reformat.sh \
      ${SUMSTATS_LIST} \
      ${FORMAT_TYPE} \
      ${OUTPUTS_DIR}
  "
  
  # Execution 

  # Cluster array execution
  JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)
  eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit
        

} 


# FUNCTIONS ==========================================================

main
