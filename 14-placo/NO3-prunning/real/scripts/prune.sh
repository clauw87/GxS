#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J prune-placo
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

module load R


INPUTS_LIST=$1
OUTPUTS=$2


# Cluster Array
RESULTS=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)

CODE=$(echo ${RESULTS} | xargs -I {} basename {} | cut -d"." -f1)


Rscript ./real/scripts/SNPclip.R ${CODE} ${RESULTS} ${OUTPUTS}
