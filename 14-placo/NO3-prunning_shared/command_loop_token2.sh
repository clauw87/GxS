#!/bin/bash

#rm -rf ./real/outputs_loop/*
#ls ../3-clump-to-count/real/tmp_1/*.coord.txt.gz  > ./real/inputs/joblist.txt


JOBS_LIST=./real/inputs/joblist_1.txt

OUTPUTS_DIR=./real/outputs_loop
#mkdir ${OUTPUTS_DIR}

COMMAND="./real/scripts/prune_loop_token2.sh ${JOBS_LIST} ${OUTPUTS_DIR}"
#JOBS_COUNT=$(cat ${JOBS_LIST} | wc -l)

sbatch ${COMMAND}


#sbatch --array=1-${JOBS_COUNT} ./real/scripts/prune.sh \
#                               ${JOBS_LIST} \
#                               ${OUTPUTS_DIR}
#
