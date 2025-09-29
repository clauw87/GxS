

OUTPUTS_DIR=./real/tmp
SUMSTATS_LIST=real/inputs/sumstats.list


COMMAND="./real/scripts/zcat.sh ${SUMSTATS_LIST}"

JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)
sbatch --array=1-${JOBS_COUNT} ${COMMAND}


