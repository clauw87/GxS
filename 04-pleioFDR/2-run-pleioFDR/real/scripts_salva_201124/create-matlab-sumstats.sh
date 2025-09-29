#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J create-matlab
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-01:30 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load Python/3.6.6-foss-2018b

# Config
FILE=$1
OUTPUT_DIR=$2
PYTHON_CONVERT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/software/python_convert/
SNPS_REF_FILE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/software/pleiofdr/data/9545380.ref
#SNPS_REF_FILE=./95.ref


CODE=$(basename ${FILE} | cut -d '.' -f1)

CSV_FILE=${OUTPUT_DIR}/${CODE}.csv
MAT_FILE=${OUTPUT_DIR}/${CODE}.mat


# Execution
## Creates CSV File
python \
  ${PYTHON_CONVERT_DIR}/sumstats.py \
    csv \
    --auto \
    --sumstats ${FILE} \
    --out ${CSV_FILE}

## Creates MAT file
python \
  ${PYTHON_CONVERT_DIR}/sumstats.py \
    mat \
    --sumstats ${CSV_FILE} \
    --ref ${SNPS_REF_FILE} \
    --out ${MAT_FILE}
