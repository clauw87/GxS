#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J cmerge-0
#SBATCH --mem 300G # memory pool for all cores
#SBATCH -t 1-16:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address




INPUTS_LIST=$1
ORI_FOLDER=$2



#module load R
module load R/3.5.1-foss-2018b



# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  RES=$(cat "${INPUTS_LIST}" | sed -n 1p)
  CODE1_CODE2=$(cat "${INPUTS_LIST}" | cut -d '/' -f4 | sed -n 1p)
else
  CODE1_CODE2=$(cat "${INPUTS_LIST}" | cut -d '/' -f4 | sed -n ${SLURM_ARRAY_TASK_ID}p)
  RES=$(cat "${INPUTS_LIST}" |sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 



CODE1=$(echo ${CODE1_CODE2} | cut -d '_' -f1)
CODE2=$(echo ${CODE1_CODE2} | cut -d '_' -f2)




# clumped pleio results file

# input munged sumstats
ORI=$(ls -d ${ORI_FOLDER}/* | grep ${CODE1_CODE2})


echo $RES
echo $ORI


Rscript ./real/scripts/results_format.R $RES $ORI




