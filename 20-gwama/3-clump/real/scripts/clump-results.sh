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
OUTPUT_DIR=$3

# Cluster Array

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
#FILE=$(cat "${INPUTS_LIST}" | sed -n 1p)
FILE=${INPUTS_LIST}
else
FILE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi



# Variables
CODE=$(echo ${FILE}  | xargs -I {} basename {} | cut -d '.' -f1)


# Creates output dir
OUTPUT_DIR=${OUTPUT_DIR}/${CODE}
mkdir -p ${OUTPUT_DIR}


# Clumps results
# results aready filtered to significant on sexx diff test i (gw) or ii (fdr<0.05)
# so, no filter on p --clump-p1 0.00001 
# Elena Bernabeu did r2>0.2 in 10MB
# removed ld-window-kb 500 for 10000
# loci-merge-kb defaults to 250, will make it 1 so not to merge loci
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/software/python_convert/sumstats.py clump \
	--clump-field pdiff \
	--force  \
	--sumstats ${FILE} \
        --ld-window-kb 10000 \
        --loci-merge-kb 0 \
        --indep-r2 0.2 \
        --lead-r2 0.2 \
	--bfile-chr /gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/data/ref_1kG_phase3_EUR/chr@ \
        --exclude-ranges 6:25119106-33854733 8:7200000-12500000 \
	--clump-p1 1 \
	--out ${OUTPUT_DIR}/result.clump


