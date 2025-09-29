#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J gene-analysis
#SBATCH --mem 120G # memory pool for all cores
#SBATCH -t 0-20:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules


# Config
JOBLIST=$1
DB=$2
OUTPUT_DIR=$3

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item corresponding to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  #DB=$(cat ${JOBLIST} | sed -n 1p | cut -d" " -f1)
  FILE=$(cat ${JOBLIST} | sed -n 1p)
  #CODE=$(basename ${FILE} | cut -d "." -f1)
  #POP=$(cat ${JOBLIST} | sed -n 1p | cut -d" " -f3)
else
  #DB=$(cat ${JOBLIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f1)
  FILE=$(cat ${JOBLIST}  | sed -n ${SLURM_ARRAY_TASK_ID}p)
  #CODE=$(basename ${FILE} | cut -d "." -f1)
  #POP=$(cat ${JOBLIST}  | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f3)
fi 






Rscript ./real/scripts/check_results.R $FILE $DB
