#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J SECA
#SBATCH --mem 120G
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR




# Modules
#module load R

module purge
module load modulepath/haswell
module load R/4.3.2-gfbf-2023a




# Config
RUN_DIR=$1
TMP_DIR=$2
INPUT_DIR=$3

OUTPUT_DIR=$4

ARRAY_LIST=${INPUT_DIR}/inputs.list_${RUN_DIR}



./real/scripts/job2.sh ${TMP_DIR} ${INPUT_DIR}/inputs.list_${RUN_DIR}


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  FILE=(`cat ${ARRAY_LIST} | sed -n 1p`)
else
  FILE=(`cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p`)
fi


CODE=$(basename ${FILE} | sed s/.gz//g)

OUTPUT_CODE=${OUTPUT_DIR}/${CODE}

mkdir ${OUTPUT_CODE}

cp ${FILE} ${OUTPUT_CODE}/

#cd ${OUTPUTS_CODE}

Rscript ./real/scripts/SECA_Ranalysis.R ${CODE}.gz ${CODE} ${OUTPUT_CODE}



