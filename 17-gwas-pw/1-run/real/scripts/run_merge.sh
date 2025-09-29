#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J merge
#SBATCH --mem 64G # memory pool for all cores
#SBATCH -t 0-03:59 # time (D-HH:MM)
#SBATCH -o ./real/tmp/messages.log.%j.out # STDOUT
#SBATCH -e ./real/tmp/messages.log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address




# Modules
module load R


# Configuration


# Config
PAIR_LIST=$1
INPUT_DIR=$2
OUTPUT_DIR=$3
SUFFIX=$4



# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  PAIR=$(cat ${PAIR_LIST} | sed -n 1p)
else
  PAIR=$(cat ${PAIR_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 


CODE1=$(echo ${PAIR} | cut -d':' -f1)
CODE2=$(echo ${PAIR} | cut -d':' -f2)



Rscript ./real/scripts/merge.R ${CODE1} ${CODE2} ${SUFFIX} ${INPUT_DIR} ${OUTPUT_DIR}

