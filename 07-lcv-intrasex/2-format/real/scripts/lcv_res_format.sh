#!/bin/bash
#
#SBATCH --partition=haswell   # partition (queue) --partition=haswell -p normal 
#SBATCH -N 1 # number of nodes
#SBATCH -J lcvformat
#SBATCH --mem 120G # memory pool for all cores
#SBATCH -t 100-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


# Modules
#module load R
#module load Python/3.6.6-foss-2018b
module load R/4.2.0-foss-2021b



# Config
RESULTS_LIST=$1
OUTPUT_DIR=$2

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  INPUT_FILE=$(cat ${RESULTS_LIST} | sed -n 1p)
  PATH1=(`cat ${RESULTS_LIST} | sed -n 1p | cut -d ' ' -f 1`)
  #PATH2=(`cat ${RESULTS_LIST} | sed -n 1p | cut -d ' ' -f 2`)
else
  INPUT_FILE=$(cat ${RESULTS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
  PATH1=(`cat ${RESULTS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f 1`)
  #PATH2=(`cat ${RESULTS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f 2`)
fi 



# Execution
Rscript ./real/scripts/lcv_res_format.R \
    ${PATH1} \
    ${OUTPUT_DIR}



