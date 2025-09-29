#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J GECKO
#SBATCH --mem 120G
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR



# Modules
module load R

# Config
TRAIT_PAIRS=$1     # list with all trait pairs combinations (pathtrait1 pathtrait2)
OUTPUT_DIR=$2  
LDSCORES=$3         # FILE with european reference LD score
SUFFIX=$4


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  FILE1=(`cat ${TRAIT_PAIRS} | sed -n 1p | cut -d ' ' -f 1`)
  FILE2=(`cat ${TRAIT_PAIRS} | sed -n 1p | cut -d ' ' -f 2`)
  #CODE1=$(basename ${FILE1} | sed s/.gecko-munged-sumstats.gz//g)
  CODE1=$(basename ${FILE1} | sed s/${SUFFIX}//g)
  CODE2=$(basename ${FILE2} | sed s/${SUFFIX}//g)
else
  FILE1=(`cat ${TRAIT_PAIRS} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f 1`)
  FILE2=(`cat ${TRAIT_PAIRS} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f 2`)
  CODE1=$(basename ${FILE1} | sed s/${SUFFIX}//g)
  CODE2=$(basename ${FILE2} | sed s/${SUFFIX}//g)
fi



Rscript ./real/scripts/gecko.R ${FILE1} ${FILE2} ${LDSCORES} ${CODE1} ${CODE2} ${OUTPUT_DIR}
