#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J compare
#SBATCH --mem 300G # memory pool for all cores # failed with 60 core dumped
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
  CODE=$(cat "${INPUTS}" | sed -n 1p)
else
  CODE=$(cat "${INPUTS}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 



# pleio and pleiofdr clumped results file, code list


Rscript ./real/scripts/loci_overlap.R ${CODE} ${OUTDIR}




