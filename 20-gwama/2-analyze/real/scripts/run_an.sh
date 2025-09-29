#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J anres
#SBATCH --mem 16G
#SBATCH -t 0-03:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR



# Modules

# Config
ARRAY_LIST=$1   
OUTPUT_DIR=$2  


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  FILE=$(cat ${ARRAY_LIST} | sed -n 1p | cut -f1)
else
  FILE=$(cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -f1)
fi


CODE=$(echo $FILE | xargs -I {} basename {} | cut -d '.' -f1)

CODE1=$(echo $CODE | cut -d ':' -f1)

ORI1=../../08-coloc/0-munge/real/outputs/${CODE1}.coloc-munged-sumstats.gz

zcat ${ORI1} | cut -f1,2,3 > ./real/inputs/${CODE}.coords

COORDS=./real/inputs/${CODE}.coords


Rscript ./real/scripts/check_results.R ${FILE} ${CODE} ${COORDS} ${OUTPUT_DIR}
