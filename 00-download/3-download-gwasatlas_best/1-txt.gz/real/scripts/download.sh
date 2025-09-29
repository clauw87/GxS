#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J down-gz
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load Python/3.6.6-foss-2018b



# Config
#SOMETHING=$1

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item corresponding to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  CODE=$(cat ./real/inputs/jobsList.txt | sed -n 1p | cut -d" " -f1)
  FILE=$(cat ./real/inputs/jobsList.txt | sed -n 1p | cut -d" " -f2)
else
  CODE=$(cat ./real/inputs/jobsList.txt | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f1)
  FILE=$(cat ./real/inputs/jobsList.txt | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f2)
fi


#python ./test/scripts/atlas_download_100.py
#python ./test/scripts/atlas_download_easyones.py


python ./real/scripts/atlas_download.py ${CODE} ${FILE}  


#wget -O ./real/outputs/${CODE} ${FILE}

