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
TMPDIR=$5

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  LOCI_FILE=$(cat "${INPUTS_LIST}" | sed -n 1p )
else
  LOCI_FILE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p )
fi 


#CODE=$(basename ${LOCI_FILE} | sed 's/.result.clump.loci.csv//g')

CODE=$(basename ${LOCI_FILE} | cut -d'.' -f1)

# DISCORDANT SNPS of the pair to check with res
# /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/2-compare-m-f/real/outputs/1214m_124m:1215f_125f.m_f.shared.5e-08.txt
cat $(ls /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/2-compare-m-f/real/outputs/*/shared_pleios_gw.txt | grep ${CODE} ) | grep -w "GW_f" | grep -w "GW_m" | grep -w DISCORDANT | cut -f1 > ${TMPDIR}/${CODE}.discordant.snps 
cat $(ls /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/2-compare-m-f/real/outputs/*/shared_pleios_gw.txt | grep ${CODE} ) | grep -w "GW_f" | grep -w "GW_m" | grep -w CONCORDANT | cut -f1 > ${TMPDIR}/${CODE}.concordant.snps




#cat $(ls /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/2-compare-m-f/real/outputs/*/gw_pleios.txt | grep ${CODE} ) | grep -w DISCORDANT | grep -w "GW_f" | grep -w "GW_m" | cut -f1 > ./real/tmp/${CODE}.discordant.snps
#cat $(ls /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/2-compare-m-f/real/outputs/*/gw_pleios.txt | grep ${CODE} ) | grep -w CONCORDANT | grep -w "GW_f" | grep -w "GW_m" | cut -f1 > ./real/tmp/${CODE}.concordant.snps



Rscript ./real/scripts/run_coloc.R ${LOCI_FILE} ${CODE} ${INPUTDIR} ${SUX} ${OUTPUTSDIR}
