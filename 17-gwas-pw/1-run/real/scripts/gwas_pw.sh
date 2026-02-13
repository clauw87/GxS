#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -J gwas-pw
#SBATCH --mem 120G
#SBATCH -t 0-13:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/messages.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/messages.log.%j.err # STDERR


# Modules
#module load gwas-pw/0.21-GCC-11.2.0
module purge
module load modulepath/haswell
module load gwas-pw/0.21-GCC-12.3.0

# Configuration


# Config
FILE_LIST=$1
INPUT_DIR=$2
TMP_DIR=$3
OUTPUT_DIR=$4

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  INPUT_FILE=$(cat ${FILE_LIST} | sed -n 1p)
else
  INPUT_FILE=$(cat ${FILE_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 


CODE=$(basename ${INPUT_FILE} | sed 's/.gz//g')
SID1=$(echo ${CODE}| cut -d ':' -f1)
SID2=$(echo ${CODE}| cut -d ':' -f2)



# Remove extreme Z values or zero/near zero variance SNPs
zcat  ${TMP_DIR}/${CODE}.gz | head -n1   > ${TMP_DIR}/${CODE}.clean
zcat  ${TMP_DIR}/${CODE}.gz | awk '  ($4 < 40 && $6 < 40 && $4 != "" && $6 != "" && $4 != "NA" && $6 != "NA" && $4 != "nan" && $6 != "nan" &&  $4 != "inf" && $6 != "inf" && $4 != "Inf" && $6 != "Inf" )' >>  ${TMP_DIR}/${CODE}.clean
gzip  ${TMP_DIR}/${CODE}.clean


# Run


#gwas-pw -i real/tmp/a8m:a9m.gz -bed ./real/inputs/ldetect-data/EUR/fourier_ls-all_ordered_ok.bed -phenos a8m a9m -o ./test/outputs/a8m:a9m

GCOV_INT_FILE=../../02-ldsc/4-gen-env-over/real/outputs/sample.overlap.txt
COR=$(cat ${GCOV_INT_FILE} | grep -w ${SID1} | grep -w ${SID2} | cut -f3)

gwas-pw -i ${TMP_DIR}/${CODE}.clean.gz -cor ${COR} -bed ${INPUT_DIR}/ldetect-data/EUR/fourier_ls-all_ordered_ok.bed -phenos ${SID1} ${SID2} -o ${OUTPUT_DIR}/${CODE}.cor









