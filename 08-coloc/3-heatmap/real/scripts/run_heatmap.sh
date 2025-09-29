#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J coloc
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 9-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/messages.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/messages.log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load R


# Config
ARRAY_LIST=$1
RES=$2
OUTPUT=$3




# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  TARGET_TYPE=$(cat "${ARRAY_LIST}" | sed -n 1p )
else
  TARGET_TYPE=$(cat "${ARRAY_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p )
fi 


PREF=$(echo ${TARGET_TYPE} | cut -d' ' -f1)
INF=$(echo ${TARGET_TYPE} | cut -d' ' -f2)


Rscript ./real/scripts/heatmap.R ${RES} ${PREF} ${INF} ${OUTPUT}
