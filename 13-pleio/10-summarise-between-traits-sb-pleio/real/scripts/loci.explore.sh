#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J lociex
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 1-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
#module load Python/3.7.4-GCCcore-8.3.0
#module load Python/3.6.6-foss-2018b
module load R/4.1.2-foss-2021b



# Config
INPUTSLIST=$1
OUTPUTDIR=$2


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  PAIR=$(cat "${INPUTS_LIST}" | sed -n 1p)
else
  PAIR=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 


Rscript ./real/scripts/loci.explore.R ${PAIR} ${OUTPUTDIR}
