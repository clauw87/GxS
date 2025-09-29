#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J munge-sumstats
#SBATCH --mem 80G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load ldsc/v1.0.1-Miniconda2-4.6.14
source activate ldsc

# Config
INPUTS_LIST=$1
OUTPUT_DIR=$2
REF_ALLELES=$3



# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  INPUT_FILE=$(cat "${INPUTS_LIST}" | sed -n 166p)
else
  INPUT_FILE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 

# Execution
BASENAME=$( basename ${INPUT_FILE} | sed s/'.ldsc-munged-sumstats.gz'//g)
munge_sumstats.py \
  --signed-sumstats Z,0 \
  --ignore BETA \
  --chunksize 50000 \
  --sumstats ${INPUT_FILE} \
  --out ${OUTPUT_DIR}/${BASENAME} \
  --merge-alleles ${REF_ALLELES}


# --signed-sumstats
# --ignore BETA
# --signed-sumstats BETA,0
# --ignore Z


mv ${OUTPUT_DIR}/${BASENAME}.sumstats.gz ${OUTPUT_DIR}/${BASENAME}.munged-sumstats.gz



conda deactivate
