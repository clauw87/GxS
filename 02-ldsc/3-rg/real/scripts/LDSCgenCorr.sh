#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J LDSCgenCorr
#SBATCH --mem 80G # memory pool for all cores
##SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
#module load ldsc/v1.0.1-Miniconda2-4.6.14
module purge
module load modulepath/noarch
module load ldsc/v1.0.1-Miniconda3-23.9.0-0

source activate ldsc

# Config
ARRAY_LIST=$1 #list with all trait pairs combinations (pathtrait1 pathtrait2)

#MUNGE_SUMSTATS_DIR=$2 #Input directory

LDSC_OUTPUT_DIR=$2 #Output directory
EUR_REFERENCE=$3 #directory with european reference LD score



# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  FILE1=(`cat ${ARRAY_LIST} | sed -n 1p | cut -d ' ' -f 1`)
  FILE2=(`cat ${ARRAY_LIST} | sed -n 1p | cut -d ' ' -f 2`)
  CODE1=$(basename ${FILE1} | sed s/.munged-sumstats.gz//g)
  CODE2=$(basename ${FILE2} | sed s/.munged-sumstats.gz//g)
else
  FILE1=(`cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f 1`)
  FILE2=(`cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f 2`)
  CODE1=$(basename ${FILE1} | sed s/.munged-sumstats.gz//g)
  CODE2=$(basename ${FILE2} | sed s/.munged-sumstats.gz//g)
fi





ldsc.py --ref-ld-chr ${EUR_REFERENCE} \
        --out ${LDSC_OUTPUT_DIR}/${CODE1}.${CODE2}-genetic-correlation \
        --rg ${FILE1},${FILE2} \
        --w-ld-chr ${EUR_REFERENCE} \




conda deactivate
