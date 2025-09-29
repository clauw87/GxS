#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J LDlinkR
#SBATCH --mem 200G # memory pool for all cores
#SBATCH -t 9-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/messages.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/messages.log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load R
#module load R/4.1.2-foss-2021b


# Config
INPUTS_LIST=$1
INPUTSDIR=$2
OUTPUTSDIR=$3


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number


CODES=$(cat "${INPUTS_LIST}"  | cut -f1)

#if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
#then
#  CODE=$(cat "${INPUTS_LIST}" | sed -n 1p | cut -f1)
#else
#  CODE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -f1)
#fi 



for CODE in ${CODES}

do
# ../2-compare-m-f_format/real/outputs/
cat ${INPUTSDIR}/${CODE}/shared_pleios_dis.txt | cut -f1 | tail -n+2 > ./real/tmp/${CODE}.snps
#cat ${INPUTSDIR}/${CODE}/result.clump.loci.csv | grep -v LEAD | cut -f3 > ./real/tmp/${CODE}.snps

if [ $(cat ./real/tmp/${CODE}.snps | wc -l) -ne 0 ]
then
    Rscript ./real/scripts/LDlinkR.R ${CODE} ./real/tmp/${CODE}.snps ${OUTPUTSDIR}
fi


done

