#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J clump-pleioFDR
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
#module load modulepath/noarch
module load PLINK/1.9b
module load Python/3.6.6-foss-2018b

# Config
INPUTS_LIST=$1
REFERENCE_FOLDER=$2
OUTPUT_DIR=$3



# Cluster Array
INPUT_FILE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)


# Variables
CODE=$(basename ${INPUT_FILE} | cut -d '.' -f1)


# Creates output dir
OUTPUT_DIR_CODE=${OUTPUT_DIR}/${CODE}
mkdir -p ${OUTPUT_DIR_CODE}


# Lauch all chrs jobs
for CHR in {1..22}
do
echo $CHR
python real/scripts/clump.bernabeu.py $CODE $CHR $OUTPUT_DIR_CODE
done

