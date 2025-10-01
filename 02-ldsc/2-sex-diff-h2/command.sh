#!/bin/bash

# Main Code --------------------------------------------------------


main(){

# Creates and cleans directory structure
clean_directory

# Configuration
POWER_FILE=../../01d-power-calc/real/outputs/joined_metadata_domains_power.txt
METAS_FILE=../../00-download/real/outputs/oined_metadata_domains.txt
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

  sbatch ${COMMAND} --dependency=afterany:${JOBID}
  exit

