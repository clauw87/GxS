#!/bin/bash

rm -rf ./real/outputs/*

ls ../3-clump-pleios/real/tmp/*.gz  > ./real/inputs/joblist.txt

JOBS_LIST=./real/inputs/joblist.txt
OUTPUTS_DIR=./real/outputs


COMMAND="./real/scripts/prune.sh ${JOBS_LIST} ${OUTPUTS_DIR}"


JOBS_COUNT=$(cat ${JOBS_LIST} | wc -l)

sbatch --array=1-${JOBS_COUNT} ${COMMAND}
