#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J metal
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


# Modules
module load Metal/2020-05-05-GCC-10.2.0

# Config
CONFIG_FILE=$1


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  OUTNAME=$(cat ${CONFIG_FILE} | grep -v -w name | sed -n 1p | cut -d ' ' -f1)
  SCRIPT=$(cat ${CONFIG_FILE} | grep -v -w name | sed -n 1p | cut -d ' ' -f2)
else
  OUTNAME=$(cat ${CONFIG_FILE} | grep -v -w name | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f1)
  SCRIPT=$(cat ${CONFIG_FILE} | grep -v -w name |  sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f2) 
fi


# Execution
metal ${SCRIPT}




