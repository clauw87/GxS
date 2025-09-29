#!/bin/bash
#
#SBATCH -p haswell    #normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J clump-PLACO
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 1-16:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load PLINK/1.9b
module load Python/3.6.6-foss-2018b

# Config
INPUTS_LIST=$1
TMP_DIR=$2
MUNGE_DIR=$3
REFERENCE_FOLDER=$4
POP=$5
OUTPUTS=$6
SIG_THR=$7



#REFERENCE_FOLDER=../../../../reference/1000G/${POP}/1000G_Phase3_${POP}_plink



# Cluster Array
MERGE_FILE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)


# Variables
#CODE=$(basename ${MERGE_FILE} | sed 's/.placo//g')

CODE=$(basename ${MERGE_FILE} | sed 's/.gz//g')

CODE1=$(echo $CODE | cut -d ':' -f1)


# munged of one pf the pair, though i did this in 0 coords
ORIGINAL_RESULTS=$(echo ${MUNGE_DIR}/${CODE1}.pleio-munged-sumstats.gz)


# Creates output dir
OUTPUTSCODE=${OUTPUTS}/${CODE}
mkdir -p ${OUTPUTSCODE}


# done independentñy
#Rscript real/scripts/merge.R ${INPUT_FILE} ${ORIGINAL_RESULTS} ${CODE} ${TMP_DIR}
#MERGE_FILE=${TMP_DIR}/${CODE}.placo.gz


CLUMP_FIELD=pplaco


# add --ld-window 500000 --ld-window-r2 0.2 for PLACO clumping
# did not include loci-merge-kb and defaults is 250kb to merge LD blocks 
# did not add lead-r2 and defaults is 0.1 to clump lead SNPs 
#--ld-window-kb 500 \ # to be passed to PLINK ld-window
#--indep-r2 0.2 \ # passed to PLINK ld-window-r2 0.2 # defaults to 0.6
# not to loci merge loci-merge-kb 1?
python /gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/software/python_convert/sumstats.py clump \
        --clump-field ${CLUMP_FIELD} \
        --ld-window-kb 500 \
        --indep-r2 0.2 \
        --force \
        --sumstats ${MERGE_FILE} \
        --bfile-chr ${REFERENCE_FOLDER}/1000G.${POP}.QC.@ \
        --exclude-ranges 6:25119106-33854733 \
        --clump-p1 ${SIG_THR} \
        --out ${OUTPUTSCODE}/${CODE}.${SIG_THR}.result.clump



# Merges clumped results with original ones to retrieve zscore values
#cat ${OUTPUTSCODE}/${CODE}.${SIG_THR}.result.clump.indep.csv \
#  | tail -n +2 \
#  | cut -f4 \
#  > ${OUTPUTSCODE}/${CODE}.${SIG_THR}.clumped.snps
#zcat ${ORIGINAL_RESULTS} \
#  | head -1 \
#  > ${OUTPUTSCODE}/${CODE}.${SIG_THR}.zscore-result.clumped
#zcat ${ORIGINAL_RESULTS} \
#  | grep -w -f ${OUTPUTSCODE}/${CODE}.${SIG_THR}.clumped.snps \
# >> ${OUTPUTSCODE}/${CODE}.${SIG_THR}.zscore-result.clumped
#Rscript ./real/scripts/loci_infomerge.R ${CODE} ${OUTPUTSCODE}/${CODE}.${SIG_THR}.zscore-result.clumped  ${OUTPUTSCODE}/${CODE}.${SIG_THR}.result.clump.loci.csv
