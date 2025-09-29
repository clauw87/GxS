#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J format_sumstats
#SBATCH --mem 80G # memory pool for all cores
#SBATCH -t 0-05:00 # time (D-HH:MM)
#SBATCH -o ./test/outputs/log.%j.out # STDOUT
#SBATCH -e ./test/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load Python/3.6.6-foss-2018b
#module load Python/3.10.4-GCCcore-11.3.0


# Config
SUMSTATS_LIST=$1
SNPS_FILE=$2
COLUMNS_INFO=$3
ALLELE_FREQ_FILE=$4
FORMAT_TYPE=$5
OUTPUT_DIR=$6
CHR22_REF=$7

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


# Execution
python ./test/scripts/formatmain.py \
	${INPUT_FILE} \
	${SNPS_FILE} \
	${COLUMNS_INFO} \
	${ALLELE_FREQ_FILE} \
	${FORMAT_TYPE} \
	${OUTPUT_DIR} \
  ${CHR22_REF}
