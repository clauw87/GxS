#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J clump-run
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
REFERENCE_FOLDER=$2
OUTPUT_DIR=$3

# Cluster Array
# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  INPUT=$(cat "${INPUTS_LIST}" | sed -n 1p)
else
  INPUT=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 


#ORIGINAL_RESULTS=$(echo ${INPUT} | cut -d ' ' -f1 )
ORIGINAL_RESULTS=$(echo ${INPUT})


# Variables
#CODE=$(echo ${INPUT}  | cut -d ' ' -f1 | cut -d '.' -f1)
CODE=$(echo ${INPUT}  | cut -d '_' -f2,3 | cut -d '.' -f1)


# Creates output dir
OUTPUT_DIR=${OUTPUT_DIR}/${CODE}
#mkdir -p ${OUTPUT_DIR}
mkdir ${OUTPUT_DIR}

# Clumps results
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/software/python_convert/sumstats.py clump \
	--clump-field pleio_p \
	--force  \
	--sumstats ${ORIGINAL_RESULTS} \
	--bfile-chr ${REFERENCE_FOLDER}/1000G.EUR.QC.@ \
  --exclude-ranges 6:25119106-33854733 8:7200000-12500000 \
	--clump-p1 0.00000005 \
	--out ${OUTPUT_DIR}/result.clump


# Merges clumped results with original ones to retrieve zscore values
cat ${OUTPUT_DIR}/result.clump.indep.csv \
  | tail -n +2 \
  | cut -f4 \
  > ${OUTPUT_DIR}/clumped.snps
zcat ${ORIGINAL_RESULTS} \
  | head -1 \
  > ${OUTPUT_DIR}/pleio-result.clumped
zcat ${ORIGINAL_RESULTS} \
  | grep -w -f ${OUTPUT_DIR}/clumped.snps \
  >> ${OUTPUT_DIR}/pleio-result.clumped
