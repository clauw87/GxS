#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J zcat
#SBATCH --mem 120G
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR




# Config
ARRAY_LIST=$1     # file with full path!!!!!! to pair merged files
OUTPUT_DIR=$2  


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  FILE=(`cat ${ARRAY_LIST} | sed -n 2p`)
else
  FILE=(`cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p`)
fi


NAME=$(basename $FILE | cut -d '.' -f1)
zcat ${FILE} | cut -f3,4,5,6,14 > ${OUTPUT_DIR}/${NAME}
