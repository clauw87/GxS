#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J looprune-placo
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 1-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs_loop/log.%j.out # STDOUT
#SBATCH -e ./real/outputs_loop/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

module load R


INPUTS_LIST=$1
OUTPUTS=$2


# Cluster Array
#RESULTS=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
#CODE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d"/" -f5  | cut -d"." -f1)



JOBS=($(cat ${INPUTS_LIST}))

for i in `seq 0 $(( ${#JOBS[@]} - 1 ))`
do
echo $i
#RESULTS=$(cat ${INPUTS_LIST} |  sed -n ${J}p   )
#CODE=$(cat  ${INPUTS_LIST} |  sed -n ${J}p | cut -d"/" -f5  | cut -d"." -f1 )
RESULTS=$(echo ${JOBS[i]})
CODE=$(echo ${JOBS[i]} | cut -d"/" -f5  | cut -d"." -f1)
Rscript ./real/scripts/SNPclip_token2.R ${CODE} ${RESULTS} ${OUTPUTS}
done
