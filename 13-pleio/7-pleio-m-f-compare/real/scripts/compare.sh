#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J compare
#SBATCH --mem 120G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address





module load R/3.5.1-foss-2018b



# Config
INPUTS=$1
OUTDIR=$2


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  INPUT=$(cat "${INPUTS}" | sed -n 1p)
else
  INPUT=$(cat "${INPUTS}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 



# pleio clumped results files to compare, code list
CODE1=$(echo $INPUT | cut -d ' ' -f1)
CODE2=$(echo $INPUT | cut -d ' ' -f2)






Rscript ./real/scripts/loci_overlap.R "${CODE1}" "${CODE2}"




