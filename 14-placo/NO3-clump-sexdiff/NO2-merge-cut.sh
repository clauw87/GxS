
ls real/tmp/*.coord.txt.gz > ./real/inputs/tmp.list


SUMSTATS_LIST=./real/inputs/tmp.list
OUTPUTS_DIR=./real/tmp


COMMAND="./real/scripts/cut.sh ${SUMSTATS_LIST} ${OUTPUTS_DIR}"


# Cluster array execution
JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)
eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}
exit


