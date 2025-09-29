#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J pleio-preprocess
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
#module load ldsc/v1.0.1-Miniconda2-4.6.14

module load Miniconda3/4.9.2
source activate ldsc_pleio

# Config
INPUTS_LIST=$1
OUTPUT_DIR=$2



# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

#if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
#then
#  INPUT_FILE=$(cat "${INPUTS_LIST}" | sed -n 1p)
#else
#  INPUT_FILE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
#fi 


#CODE=$(basename ${INPUT_FILE} | cut -d '.' -f1)


#python ./real/scripts/pleio/ldsc_preprocess.py $INPUT_FILE

python ./real/scripts/pleio/ldsc_preprocess.py \
	--input ${INPUTS_LIST} \
	--ref-ld-chr ../../../Software/ldsc/eur_w_ld_chr/ \
	--w-ld-chr ../../../Software/ldsc/eur_w_ld_chr/ \
	--out ${OUTPUT_DIR}

conda deactivate
