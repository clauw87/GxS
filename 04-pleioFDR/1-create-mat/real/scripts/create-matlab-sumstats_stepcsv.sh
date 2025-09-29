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
TMP_DIR=$2
OUTPUT_DIR=$3
PYTHON_CONVERT_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/software/python_convert/
SNPS_REF_FILE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/software/pleiofdr/data/9545380.ref
CODE=$(basename ${FILE} | cut -d '.' -f1)



# createss mat csv to check it
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/software/python_convert/sumstats.py \
    mat-to-csv \
    --force \
    --mat ${OUTPUT_DIR}/${CODE}.mat \
    --ref ${SNPS_REF_FILE} \
    --out ${OUTPUT_DIR}/${CODE}.mat.csv


