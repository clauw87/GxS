#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J down-other
#SBATCH --mem 200G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load Python/3.6.6-foss-2018b



# Config
#SOMETHING=$1

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item corresponding to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  CODE=$(cat ./real/inputs/jobsList.txt | grep -w female | sed -n 1p | cut  -f1)
  FILE_M=$(cat ./real/inputs/jobsList.txt | grep -w male | sed -n 1p | cut -f2 | cut -d " " -f2)
else
  CODE=$(cat ./real/inputs/jobsList.txt | grep -w female | sed -n ${SLURM_ARRAY_TASK_ID}p | cut  -f1)
  FILE_M=$(cat ./real/inputs/jobsList.txt | grep -w male | sed -n ${SLURM_ARRAY_TASK_ID}p | cut  -f2 | cut -d " " -f2)
fi





wget -O	./real/tmp/${CODE}_m.gz ${FILE_M}


wait


INPUT_FILE=./real/tmp/${CODE}_m.gz
VARIANTS_FILE=./real/inputs/variants-short.tsv.gz
OUTPUTS_DIR=./real/outputs

python ./real/scripts/reformat.py \
        ${INPUT_FILE} \
        ${VARIANTS_FILE} \
        ${OUTPUTS_DIR}  \
        ${CODE}_m


