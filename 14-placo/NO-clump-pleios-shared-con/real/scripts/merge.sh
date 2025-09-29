#!/bin/bash
#
#SBATCH -p haswell    #normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J merge
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/tmp/log.%j.out # STDOUT
#SBATCH -e ./real/tmp/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load 
module load PLINK/1.9b
module load Python/3.6.6-foss-2018b

# Config
INPUTS_LIST=$1
TMP_DIR=$2
MUNGE_DIR=$3
REFERENCE_FILE=$4
OUTPUTS=$5



# Cluster Array
INPUT_FILE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)


# Variables
CODE=$(basename ${INPUT_FILE} | sed 's/.placo//g')

CODE1=$(echo $CODE | cut -d ':' -f1)

# munged of one pf the pair, though i did this in 0 coords
ORIGINAL_RESULTS=$(echo ${MUNGE_DIR}/${CODE1}.pleio-munged-sumstats.gz)



# Creates output dir

Rscript real/scripts/merge.R ${INPUT_FILE} ${ORIGINAL_RESULTS} ${CODE} ${TMP_DIR}

