#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J fil
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 0-01:29 # time (D-HH:MM)
#SBATCH -o ./real/outputs/job2.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/job2.log.%j.err # STDERR

# Modules
module load R


FILE_LIST=$1
BEDFILE=$2
TMP_DIR=$3





# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  INPUT_FILE=$(cat ${FILE_LIST} | sed -n 1p)
else
  INPUT_FILE=$(cat ${FILE_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi



Rscript ./real/scripts/merged_filter.R ${INPUT_FILE} ${BEDFILE} ${TMP_DIR}


#gzip ${INPUT_FILE}

#mv ${INPUT_FILE}.gz ${INPUT_FILE}
 
