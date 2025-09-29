#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J power-calc
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
#module load R/4.2.0-foss-2021b
module load R/3.2.3

# Config

METADATA_LIST=$1
OUTPUTS_DIR=$2


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item corresponding to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  FILE=$( cat ${METADATA_LIST} | sed -n 1p | cut -f1 )
else
  FILE=$( cat ${METADATA_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -f1 )
fi

H2=../02-ldsc/2-join_h2_results/real/outputs/h2.txt


Rscript ./real/scripts/run_cal.R ${FILE} ${H2} ${OUTPUTS_DIR}

#Rscript ./real/scripts/run_cal.R ./real/inputs/alreadystratified_atlas.txt ./real/outputs


#wait
#Rscript ./real/scripts/rg_power.R
