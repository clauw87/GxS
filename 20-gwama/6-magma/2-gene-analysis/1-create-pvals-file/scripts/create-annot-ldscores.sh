#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J annot-ldscores
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load ldsc/v1.0.1-Miniconda2-4.6.14
source activate ldsc

# Config
GEN_COORDINATES=$1
G1000_DIR=$2
OUTPUT_DIR=$3
LDSCORES_DIR=$4
HAPMAP_SNPS=$5
GENESETS_DIR=$6
REFERENCE_GENESET=$7


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item corresponding to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  TRAIT=$(cat ./real/tmp/jobsList.txt | sed -n 1p | cut -d" " -f3)
  POP=$(cat ./real/tmp/jobsList.txt | sed -n 1p | cut -d" " -f1)
  CHR=$(cat ./real/tmp/jobsList.txt | sed -n 1p | cut -d" " -f2)  
else
  TRAIT=$(cat ./real/tmp/jobsList.txt | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f3)
  POP=$(cat ./real/tmp/jobsList.txt | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f1)
  CHR=$(cat ./real/tmp/jobsList.txt | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f2)
fi 


# Create output directory
JOB_OUTPUT_DIR=${LDSCORES_DIR}/${TRAIT}/${POP}
mkdir -p ${JOB_OUTPUT_DIR}


# Checks that reference geneset name is not the same
#  of some of the other genesets
#for GENESET in $(ls ${GENESETS_DIR}/${TRAIT}/*)
#do
#  GENESET_CODE=$(basename ${GENESET} | cut -d'.' -f1)
#  REFERENCE_CODE=$(basename ${REFERENCE_GENESET} | cut -d'.' -f1)
#  if [ ${GENESET_CODE} == ${REFERENCE_CODE} ]
#  then
#    echo Geneset name: ${GENESET_CODE} identical to reference Geneset
#    echo exiting ...
#  fi  
#done


# Create annotations for each geneset
for GENESET in $(ls ${GENESETS_DIR}/${TRAIT}/*)
do
  GENESET_CODE=$(basename ${GENESET} | cut -d'.' -f1)
  make_annot.py \
    --gene-set-file ${GENESET} \
    --gene-coord-file ${GEN_COORDINATES} \
    --windowsize 5000 \
    --bimfile ${G1000_DIR}/${POP}/1000G_Phase3_${POP}_plink/1000G.${POP}.QC.${CHR}.bim \
    --annot-file ${JOB_OUTPUT_DIR}/${GENESET_CODE}.${CHR}.annot.gz
done


# Create annotation for reference geneset
#REFERENCE_CODE=$(basename ${REFERENCE_GENESET} | cut -d'.' -f1)
#mkdir -p ${JOB_OUTPUT_DIR}/${REFERENCE_CODE}
#make_annot.py \
#  --gene-set-file ${REFERENCE_GENESET} \
#  --gene-coord-file ${GEN_COORDINATES} \
#  --windowsize 5000 \
#  --bimfile ${G1000_DIR}/${POP}/1000G_Phase3_${POP}_plink/1000G.${POP}.QC.${CHR}.bim \
#  --annot-file ${JOB_OUTPUT_DIR}/${REFERENCE_CODE}/${REFERENCE_CODE}.${CHR}.annot.gz


# Join annotations into a single file

## Baseline annotation 
zcat  ${G1000_DIR}/${POP}/1000G_Phase3_${POP}_baselineLD_v2.2/baselineLD.${CHR}.annot.gz  \
      > ${JOB_OUTPUT_DIR}/${CHR}.annot           


## Reference annotation
#paste \
#    ${JOB_OUTPUT_DIR}/${CHR}.annot \
#    <(zcat ${JOB_OUTPUT_DIR}/${REFERENCE_CODE}/${REFERENCE_CODE}.${CHR}.annot.gz) \
#  > ${JOB_OUTPUT_DIR}/${CHR}.annot.tmp
#sed -i "s/ANNOT/${REFERENCE_CODE}/" ${JOB_OUTPUT_DIR}/${CHR}.annot.tmp  
#mv ${JOB_OUTPUT_DIR}/${CHR}.annot.tmp ${JOB_OUTPUT_DIR}/${CHR}.annot


## New annotations           
for GENESET_ANNOT in $(ls ${JOB_OUTPUT_DIR}/*.${CHR}.annot.gz)
do
  GENESET_CODE=$(basename ${GENESET_ANNOT} | cut -d'.' -f1)
  paste \
      ${JOB_OUTPUT_DIR}/${CHR}.annot \
      <(zcat ${GENESET_ANNOT}) \
    >  ${JOB_OUTPUT_DIR}/${CHR}.annot.tmp
  sed -i "s/ANNOT/${GENESET_CODE}/" ${JOB_OUTPUT_DIR}/${CHR}.annot.tmp 
  mv ${JOB_OUTPUT_DIR}/${CHR}.annot.tmp ${JOB_OUTPUT_DIR}/${CHR}.annot 
done
gzip ${JOB_OUTPUT_DIR}/${CHR}.annot


# Calculate partitioned ld-scores  
ldsc.py \
  --l2 \
  --bfile ${G1000_DIR}/${POP}/1000G_Phase3_${POP}_plink/1000G.${POP}.QC.${CHR} \
  --ld-wind-cm 1 \
  --annot ${JOB_OUTPUT_DIR}/${CHR}.annot.gz \
  --out ${JOB_OUTPUT_DIR}/${CHR} \
  --print-snps ${HAPMAP_SNPS}/hm.${CHR}.snp


conda deactivate
