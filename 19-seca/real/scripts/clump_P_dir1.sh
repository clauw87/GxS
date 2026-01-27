#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -J secaClump
#SBATCH --mem 120G
#SBATCH -t 0-03:59 # time (D-HH:MM)
#SBATCH -o ./real/tmp/messages.log.%j.out # STDOUT
#SBATCH -e ./real/tmp/messages.log.%j.err # STDERR


# Modules
module purge
module load modulepath/haswell
module load PLINK/1.9b
module load R/4.3.2-gfbf-2023a


# Configuration
FILE_LIST=$1
INPUT_DIR=$2
TMP_DIR=$3


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  CODE=$(cat ${FILE_LIST} | sed -n 1p)
  #CODE=a13m:r9m
else
  CODE=$(cat ${FILE_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 


CODE1=$(echo ${CODE}| cut -d ':' -f1)
CODE2=$(echo ${CODE}| cut -d ':' -f2)


#TMP=./real/tmp
REF_BED=real/inputs/1000G_20101123_v3_GIANT_chr1_23_minimacnamesifnotRS_CEU_MAF0.01



# 2 sumstats with columns: SNP        EA  NEA  P       BETA

#FILE1GZ=${SUMSTAT_DIR}/${SID1}${SUFFIX}
#FILE2GZ=${SUMSTAT_DIR}/${SID2}${SUFFIX}
#CODE1=$(basename ${FILE1GZ} | sed 's/.coloc-munged-sumstats.gz//g')
#CODE2=$(basename ${FILE2GZ} | sed 's/.coloc-munged-sumstats.gz//g')
#zcat ${FILE1GZ} >	${TMP}/${CODE1}
#zcat ${FILE2GZ} > ${TMP}/${CODE2}
#CODE1=${SID1}
#CODE2=${SID2}

FILE1=${INPUT_DIR}/${CODE1}
FILE2=${INPUT_DIR}/${CODE2}


### P-value-informed LD clumping


# SNPs subset overlap: SNP column is $3
#awk  'NR==FNR {ARR1[$3]=$0; next} ($3 in ARR1) {print $0}' $FILE2 $FILE1  > ${TMP}/${CODE1}_overlapping_${CODE2}
# col 1
awk  'NR==FNR {ARR1[$1]=$0; next} ($1 in ARR1) {print $0}' $FILE2 $FILE1  > ${TMP_DIR}/${CODE1}_overlapping_${CODE2}


# First clumping 
plink \
--bfile ${REF_BED} \
--clump ${TMP_DIR}/${CODE1}_overlapping_${CODE2} \
--clump-snp-field SNP \
--clump-field PVAL \
--clump-p1 1 \
--clump-p2 1 \
--clump-r2 0.1 \
--clump-kb 1000 \
--out ${TMP_DIR}/${CODE1}_overlapping_${CODE2}.clump1

awk '{ print $3 }' ${TMP_DIR}/${CODE1}_overlapping_${CODE2}.clump1.clumped > ${TMP_DIR}/${CODE1}_overlapping_${CODE2}.clump1.SNPs

awk 'NR==FNR {ARR1[$3]=$0; next} ($1 in ARR1) {print $0}' ${TMP_DIR}/${CODE1}_overlapping_${CODE2}.clump1.clumped ${TMP_DIR}/${CODE1}_overlapping_${CODE2} \
> ${TMP_DIR}/${CODE1}_overlapping_${CODE2}.clump1_clump1



# Second clumping (long range LD)
plink \
--bfile ${REF_BED} \
--extract ${TMP_DIR}/${CODE1}_overlapping_${CODE2}.clump1.SNPs \
--clump ${TMP_DIR}/${CODE1}_overlapping_${CODE2}.clump1_clump1 \
--clump-field PVAL \
--clump-p1 1 \
--clump-p2 1 \
--clump-r2 0.1 \
--clump-kb 10000 \
--out ${TMP_DIR}/${CODE1}_overlapping_${CODE2}.clump2


# Generate set of indep SNPs by matching the PLINK –clump output (‘dataset1_subset_overlapping_dataset2_clump2.clumped’) which lists the independent SNPs in field #3,
# with ‘dataset1_subset_overlapping_dataset2’ GWAS summary file which has SNP in field #1 
# to obtain file ‘dataset1.independent’, containing a subset of GWAS summary results from dataset1 for a set of independent SNPs.

awk 'NR==FNR {ARR1[$3]=$0; next} ($1 in ARR1) {print $0}' ${TMP_DIR}/${CODE1}_overlapping_${CODE2}.clump2.clumped ${TMP_DIR}/${CODE1}_overlapping_${CODE2} \
> ${TMP_DIR}/${CODE1}.${CODE1}_${CODE2}.independent



# For the 2nd file
awk 'NR==FNR {ARR1[$3]=$0; next} ($1 in ARR1) {print $0}' ${TMP_DIR}/${CODE1}_overlapping_${CODE2}.clump2.clumped ${FILE2} \
> ${TMP_DIR}/${CODE2}.${CODE1}_${CODE2}.independent





# Merge in an independent aligned effects file to feed run seca.sh
INDEP_SUFFIX=.${CODE1}_${CODE2}.independent


Rscript ./real/scripts/merge.R ${CODE1} ${CODE2} ${INDEP_SUFFIX} ${TMP_DIR} ${TMP_DIR}

