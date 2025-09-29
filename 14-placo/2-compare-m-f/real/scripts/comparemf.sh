#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J compare
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 0-16:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address





module load R/3.5.1-foss-2018b



# Config
INPUTS=$1
INDIR=$2
OUTDIR=$3


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
mpair=$(echo $INPUT | cut -d ' ' -f1)
fpair=$(echo $INPUT | cut -d ' ' -f2)
#mkdir ${OUTDIR}/mpair_mfair


FILVAL1="5e-08"
Rscript ./real/scripts/comparemf.R ${mpair} ${fpair} ${INDIR} ${OUTDIR} ${FILVAL1}


#FILVAL2="1e-06"
#Rscript ./real/scripts/comparemf.R "${mpair}" "${fpair}" ${INDIR} ${OUTDIR} ${FILVAL2}


