#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J clump-betadiff
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
#module load modulepath/noarch
module load PLINK/1.9b
module load Python/3.6.6-foss-2018b

# Config
INPUTS_LIST=$1
REFERENCE_FILE=$2
OUTPUTS=$3

# Cluster Array
ORIGINAL_RESULTS=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)


# Variables
#COMP_CODE=$(echo ${ORIGINAL_RESULTS} | cut -d'/' -f3 | cut -d '.' -f1)	
COMP_CODE=$(echo ${ORIGINAL_RESULTS} | cut -d'/' -f5)

# Creates output dir
OUTPUT_DIR=${OUTPUTS}/${COMP_CODE}
mkdir -p ${OUTPUT_DIR}

#zcat ${ORIGINAL_RESULTS} | cut -f1,2,3,4,5,12,19 > ${OUTPUT_DIR}/${COMP_CODE}.min

cat ${ORIGINAL_RESULTS} | cut -f1,8,15 > ${OUTPUT_DIR}/${COMP_CODE}.min

INPUT=${OUTPUT_DIR}/${COMP_CODE}.min

# Clumps results (# suggestive p 1e-6, 0.000001 ) or fdr 0.05
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/software/python_convert/sumstats.py clump \
	--clump-field p.placo.fdr_m \
	--force  \
	--sumstats ${INPUT} \
	--bfile-chr /gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/data/ref_1kG_phase3_EUR/chr@ \
  --exclude-ranges 6:25119106-33854733 8:7200000-12500000 \
	--clump-p1 0.05 \
	--out ${OUTPUT_DIR}/m.result.clump

python /gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/software/python_convert/sumstats.py clump \
        --clump-field p.placo.fdr_f \
        --force  \
        --sumstats ${INPUT} \
        --bfile-chr /gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/data/ref_1kG_phase3_EUR/chr@ \
  --exclude-ranges 6:25119106-33854733 8:7200000-12500000 \
        --clump-p1 0.05 \
        --out ${OUTPUT_DIR}/f.result.clump



# Merges clumped results with original ones to retrieve zscore values
cat ${OUTPUT_DIR}/f.result.clump.indep.csv \
  | tail -n +2 \
  | cut -f4 \
  > ${OUTPUT_DIR}/f.clumped.snps
cat ${ORIGINAL_RESULTS} \
  | head -1 \
  > ${OUTPUT_DIR}/f.placo-result.clumped
cat ${ORIGINAL_RESULTS} \
  | grep -w -f ${OUTPUT_DIR}/f.clumped.snps \
  >> ${OUTPUT_DIR}/f.placo-result.clumped


# Merges clumped results with original ones to retrieve zscore values
cat ${OUTPUT_DIR}/m.result.clump.indep.csv \
  | tail -n +2 \
  | cut -f4 \
  > ${OUTPUT_DIR}/m.clumped.snps
cat ${ORIGINAL_RESULTS} \
  | head -1 \
  > ${OUTPUT_DIR}/m.placo-result.clumped
cat ${ORIGINAL_RESULTS} \
  | grep -w -f ${OUTPUT_DIR}/m.clumped.snps \
  >> ${OUTPUT_DIR}/m.placo-result.clumped

