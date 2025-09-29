#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J clump-pleioFDR
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
TMP_DIR=$2
REFERENCE_FILE=$2
OUTPUTS=$3

# Cluster Array
INPUT_FILE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)

# Variables
CODE=$(basename ${INPUT_FILE} | sed 's/.cut.txt.gz//g')
ORIGINAL_RESULTS=$(echo ${TMP_DIR}/${CODE}.coord.txt.gz)


# Creates output dir
OUTPUTSCODE=${OUTPUTS}/${CODE}
mkdir -p ${OUTPUTSCODE}




python /gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/software/python_convert/sumstats.py clump \
        --clump-field sexdiffp \
        --force \
        --sumstats ${TMP_DIR}/${CODE}.cut.txt.gz \
        --bfile-chr /gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/data/ref_1kG_phase3_EUR/chr@ \
        --exclude-ranges 6:25119106-33854733 \
        --clump-p1 0.05 \
        --out ${OUTPUTSCODE}/${CODE}.result.clump



# Merges clumped results with original ones to retrieve zscore values
cat ${OUTPUT_DIR}/${CODE}.result.clump.indep.csv \
  | tail -n +2 \
  | cut -f4 \
  > ${OUTPUT_DIR}/${CODE}.clumped.snps
zcat ${ORIGINAL_RESULTS} \
  | head -1 \
  > ${OUTPUT_DIR}/${CODE}.zscore-result.clumped
zcat ${ORIGINAL_RESULTS} \
  | grep -w -f ${OUTPUT_DIR}/${CODE}.clumped.snps \
 >> ${OUTPUT_DIR}/${CODE}.zscore-result.clumped

