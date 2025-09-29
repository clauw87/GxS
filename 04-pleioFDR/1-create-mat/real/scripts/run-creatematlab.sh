#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J run-pleioFDR
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-03:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


# Modules
module load Python/3.6.6-foss-2018b
module load MATLAB/2020a


# Config
SUMSTATS_LIST=$1
TMP_DIR=$2
OUTPUT_DIR=$(readlink -f $3) # Convert to absolute path

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  FILE=$(cat "${SUMSTATS_LIST}" | sed -n 1p)
  #FILE=(`cat ${SUMSTATS_LIST} | sed -n 1p | cut -d ' ' -f 1`)
  CODE=$(basename ${FILE} | cut -d '.' -f1)
else
  FILE=$(cat "${SUMSTATS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
  #FILE=(`cat ${SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f 1`)
  CODE=$(basename ${FILE} | cut -d '.' -f1)
fi


# Execution
## Creates Matlab Sumstats for trait
bash ./real/scripts/create-matlab-sumstats.sh \
        ${FILE} \
        ${TMP_DIR} \
        ${OUTPUT_DIR} \
 


