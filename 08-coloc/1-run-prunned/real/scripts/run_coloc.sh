#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J coloc
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 9-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/messages.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/messages.log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load R



# Config
INPUTS_LIST=$1
INPUTDIR=$2
SUX=$3
OUTPUTSDIR=$4
TMPSDIR=$5
TYPEP=$6


LOCI_FILE=$INPUTS_LIST

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  PAIRMF=$(cat "${INPUTS_LIST}" | grep -v pair | cut -f4 | sort -u | sed -n 1p )
else
  PAIRMF=$(cat "${INPUTS_LIST}" | grep -v pair | cut -f4 | sort -u | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 



#CODE=$(cat ${LOCI_FILE} | cut -f54)


PAIRM=$(echo $PAIRMF | cut -d':' -f1,2)
PAIRF=$(echo $PAIRMF | cut -d':' -f3,4)


# DISCORDANT SNPS of the pair to check with res
# /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/2-compare-m-f/real/outputs/1214m_124m:1215f_125f.m_f.shared.5e-08.txt
cat $(ls /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/2-compare-m-f/real/outputs/*/shared_pleios_gw.txt | grep ${PAIRMF} ) | grep -w "GW_f" | grep -w "GW_m" | grep -w DISCORDANT | cut -f1 > ${TMPSDIR}/${PAIRMF}.discordant.snps 
cat $(ls /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/2-compare-m-f/real/outputs/*/shared_pleios_gw.txt | grep ${PAIRMF} ) | grep -w "GW_f" | grep -w "GW_m" | grep -w CONCORDANT | cut -f1 > ${TMPSDIR}/${PAIRMF}.concordant.snps



Rscript ./real/scripts/run_coloc.R ${LOCI_FILE} ${PAIRMF} ${PAIRM} ${INPUTDIR} ${SUX} ${OUTPUTSDIR} ${TYPEP}
Rscript ./real/scripts/run_coloc.R ${LOCI_FILE} ${PAIRMF} ${PAIRF} ${INPUTDIR} ${SUX} ${OUTPUTSDIR} ${TYPEP}


