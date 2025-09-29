#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J Ancestral
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-20:00 # time (D-HH:MM)
#SBATCH -o ./outputs/log.%j.out # STDOUT
#SBATCH -e ./outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=eva.brigos@upf.edu # send-to address


# Configuration
INPUT_FILE=$1
OUTPUT_RSID=$2
OUTPUT_ANCESTRAL=$3
MERGED_OUTPUT=$4

#--Commands
zcat ${INPUT_FILE} | perl -nle 'print $1 if /dbSNP_138:(.+?);/' > ${OUTPUT_RSID}

zcat ${INPUT_FILE} | perl -nle 'print $1 if /ancestral_allele=(.+?);/' > ${OUTPUT_ANCESTRAL}

paste ${OUTPUT_RSID} ${OUTPUT_ANCESTRAL} > ${MERGED_OUTPUT}

sed  -i '1i RSID\tANCESTRAL_ALLELE' ${MERGED_OUTPUT}

gzip ${MERGED_OUTPUT}

gzip ${OUTPUT_RSID}

gzip ${OUTPUT_ANCESTRAL}
