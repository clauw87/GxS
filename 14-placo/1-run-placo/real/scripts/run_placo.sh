#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J placo
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 9-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/messages.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/messages.log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load R



# Config
INPUTS_LIST=$1
INPUTSDIR=$2
OUTPUTSDIR=$3
SUFFIX=$4

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  CODE1=$(cat "${INPUTS_LIST}" | sed -n 1p | cut -d ' ' -f1)
  CODE2=$(cat "${INPUTS_LIST}" | sed -n 1p | cut -d ' ' -f2)
else
  CODE1=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f1)
  CODE2=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f2)
fi 



#Rscript ./real/scripts/run_placo.R ${CODE1} ${CODE2} ${INPUTSDIR} ${OUTPUTSDIR} ${SUFFIX}

Rscript ./real/scripts/run_placo_smartdecor.R ${CODE1} ${CODE2} ${INPUTSDIR} ${OUTPUTSDIR} ${SUFFIX}
