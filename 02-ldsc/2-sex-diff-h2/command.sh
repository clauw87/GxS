#!/bin/bash

# Main Code --------------------------------------------------------


main(){

  # Creates and cleans directory structure
  clean_directory

  # Configuration
  POWER_FILE=../2-join_h2_results/real/outputs/h2_powered_2.txt
  #METAS_FILE=/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01d-power-calc/real/outputs/metadata_target_power.txt
  METAS_FILE=/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains_updated.txt
  OUTPUTS_DIR=./real/outputs

  # POWER CALC - Add liability scale column
  POWER="/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01d-power-calc/command.sh"
  JOBID=$(sbatch ${POWER})


  # COMMAND
  COMMAND=" \
    ./real/scripts/run.sh \
        ${POWER_FILE} \
        ${METAS_FILE} \
        ${OUTPUTS_DIR}
  "

  # Execution
  # Cluster execution
  #JOBS_COUNT=$(cat "${FORMATTED_SUMSTATS_LIST}" | wc -l)
  #sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  #exit

  sbatch ${COMMAND} --dependency=afterany:${JOBID}
  exit

  # Direct execution
  bash ${COMMAND}
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
