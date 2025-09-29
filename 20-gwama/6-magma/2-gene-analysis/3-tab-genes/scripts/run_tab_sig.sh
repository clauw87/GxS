#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J siggene
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail


JOBLIST=$1
OUTPUT_DIR=$2

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item corresponding to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  #TRAIT=$(cat ${JOBLIST} | sed -n 1p | cut -d" " -f1)
  FILE=$(cat ${JOBLIST} | sed -n 1p | cut -d" " -f1)
  CODE=$(basename ${FILE} | cut -d "." -f1)
else
  #TRAIT=$(cat ${JOBLIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f1)
  FILE=$(cat ${JOBLIST}  | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f1)
  CODE=$(basename ${FILE} | cut -d "." -f1)
fi 


# Launch gene analysis
Rscript ./real/scripts/tab-sig-gene.R ${FILE} ${CODE} ${OUTPUT_DIR}
