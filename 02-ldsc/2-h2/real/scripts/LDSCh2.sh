#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J LDSC_h2
#SBATCH --mem 60G # memory pool for all cores
##SBATCH -t 0-01:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load ldsc/v1.0.1-Miniconda2-4.6.14
source activate ldsc

# Config
SUMSTATS_LIST=$1
LDSC_OUTPUT_DIR=$2 # Output directory
EUR_REFERENCE=$3 # directory with European reference LD score from LDSC software


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  FILE=(`cat ${SUMSTATS_LIST} | sed -n 1p | cut -d ' ' -f 1`)
  CODE=$(basename ${FILE} | sed s/.munged-sumstats.gz//g)
else
  FILE=(`cat ${SUMSTATS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f 1`)
  CODE=$(basename ${FILE} | sed s/.munged-sumstats.gz//g)
fi


ldsc.py --h2 ${FILE} \
        --ref-ld-chr ${EUR_REFERENCE} \
        --w-ld-chr ${EUR_REFERENCE} \
        --out ${LDSC_OUTPUT_DIR}/${CODE}-h2 \



conda deactivate
