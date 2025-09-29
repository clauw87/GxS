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
#module load R
module load R/4.1.2-foss-2021b


# Config
CODE=$1
INPUTSDIR=$2
SUFF=$3
OUTPUTSDIR=$4




cat ${INPUTSDIR}/${CODE}/result.clump.loci.csv | grep -v LEAD | cut -f3 > ./real/tmp/${CODE}.snps


#cat ${INPUTSDIR}/${CODE}${SUFF} | grep -v -w SNP > ./real/tmp/${CODE}.snps


if [ $(cat ./real/tmp/${CODE}.snps | wc -l) -ne 0 ]
then
    #Rscript ./real/scripts/LDlinkR.R ${CODE} ./real/tmp/${CODE}.snps ${OUTPUTSDIR}
     Rscript ./real/scripts/LDlinkR_per_trait.R ${CODE} ${SUFF} ${INPUTSDIR} ${OUTPUTSDIR}
fi



