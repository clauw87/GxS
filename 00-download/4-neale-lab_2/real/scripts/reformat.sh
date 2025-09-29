#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J ukbbreformal
#SBATCH --mem 80G # memory pool for all cores
#SBATCH -t 0-05:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load Python/3.6.6-foss-2018b

# Config
SUMSTATS_LIST=$1
VARIANTS_FILE=$2
OUTPUTS_DIR=$3

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
  CODE=$(cat ${SUMSTATS_LIST} | sed -n 1p  | cut -d '/' -f4 | cut -d '.' -f1)
else
  INPUT_FILE=$(cat ${SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
  CODE=$(cat ${SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p  | cut -d '/' -f4 | cut -d '.' -f1)
fi 


# Execution
python ./real/scripts/reformat.py \
	${INPUT_FILE} \
	${VARIANTS_FILE} \
	${OUTPUTS_DIR}	\
	${CODE}
