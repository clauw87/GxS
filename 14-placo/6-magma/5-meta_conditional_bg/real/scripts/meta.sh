

ANALYSIS=$1
RES_FILE=$2
#OUTPUT_DIR=$2


module load R

Rscript ./real/scripts/meta.R ${ANALYSIS} ${RES_FILE}
