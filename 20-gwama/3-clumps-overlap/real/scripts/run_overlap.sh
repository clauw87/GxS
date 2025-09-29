#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J overlap
#SBATCH --mem 64G # memory pool for all cores
#SBATCH -t 0-23:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load R

# Config
ARRAY_LIST=$1
LOCI_DIR=$2
OUTPUT_DIR=$3





# Cluster Array
LOCI1=$(cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f1)
LOCI2=$(cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f2)

CODE1=$(echo $LOCI1 | cut -d '/' -f5)
CODE2=$(echo $LOCI2 | cut -d '/' -f5)



Rscript ./real/scripts/overlap.R ${CODE1} ${CODE2} ${LOCI_DIR}
