#!/bin/bash
#
#SBATCH --partition=haswell   # partition (queue) --partition=haswell -p normal 
#SBATCH -N 1 # number of nodes
#SBATCH -J pleioplot
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 100-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


# Modules
#module load R
module load Python/3.6.6-foss-2018b
#module load R/4.2.0-foss-2021b



# Config
LOGS_LIST=$1
OUT_DIR=$2

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  LOG=$(cat ${LOGS_LIST} | sed -n 1p)
  #PATH=(`cat ${PATH_LIST} | sed -n 1p | cut -d ' ' -f 1`)
else
  LOG=$(cat ${LOGS_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
  #PATH=(`cat ${PATH_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f 1`)
fi 


ID="${SLURM_ARRAY_TASK_ID}"
# Execution


# log of ldsc
#LOG=../3-preprocess/real/outputs/log.22487536.out
#LOGS=$(ls ../3-preprocess/real/outputs/log.* | grep out | grep -v err | grep -v messages)


# header
cat $LOG | grep -w p1 | grep -w p2 | head -n1 > ./real/tmp/ldsc_log_${ID}.txt

# rows
cat $LOG | grep gz | grep 0 >> ./real/tmp/ldsc_log_${ID}.txt 



module load R

Rscript ./real/scripts/get_from_log.R ./real/tmp/ldsc_log_${ID}.txt ${OUT_DIR}

