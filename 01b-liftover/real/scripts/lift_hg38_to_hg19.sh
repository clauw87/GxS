#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J liftover
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


module load Python/3.8.2-GCCcore-9.3.0  

# Config
FILE=$1
CHR=$2
BP=$3

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item corresponding to the array number
#if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
#then
#  CHR=22
#else
#  CHR=${SLURM_ARRAY_TASK_ID}
#fi 



python ./real/scripts/lift_hg38_to_hg19.py ${FILE} ${CHR} ${BP}
