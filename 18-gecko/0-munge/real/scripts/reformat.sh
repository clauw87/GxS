#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J reformat_sumstats
#SBATCH -t 0-05:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address



#   --mem 80G # memory pool for all cores

# Modules
module load Python/3.6.6-foss-2018b


# Config
SUMSTATS_LIST=$1
FORMAT_TYPE=$2
OUTPUT_DIR=$3


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  INPUT_FILE=$(cat ${SUMSTATS_LIST} | sed -n 1p)
else
  INPUT_FILE=$(cat ${SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi


TRAIT_CODE=$(echo $(basename ${INPUT_FILE})  | sed s/.formatted.sumstats.gz//g )


# Execution
python ./real/scripts/reformat.py \
	${INPUT_FILE} \
        ${TRAIT_CODE} \
	${FORMAT_TYPE} \
	${OUTPUT_DIR}
