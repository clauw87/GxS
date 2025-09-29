#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J hyprcoloc
#SBATCH --mem 400G # memory pool for all cores
#SBATCH -t 9-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/messages.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/messages.log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module R/3.6.0-foss-2018b


# Config
INPUT_DIR=$1
SEX_FILE=$2

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  SEX=$(cat "${SEX_FILE}" | sed -n 1p )
else
  SEX=$(cat "${SEX_FILE}" | sed -n ${SLURM_ARRAY_TASK_ID}p )
fi 


Rscript real/scripts/run_hyprcoloc.R ${INPUT_DIR} ${SEX}
