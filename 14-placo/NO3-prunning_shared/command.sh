#!/bin/bash


OUTPUTS_DIR=./real/outputs_batch 
mkdir ${OUTPUTS_DIR}

#ls ../3-clump-to-count/real/tmp_1/*.coord.txt.gz  > ./real/inputs/joblist.txt


#JOBS_LIST=./real/inputs/joblist_2.txt

JOBS_LIST=./real/inputs/joblist_6.txt



COMMAND="./real/scripts/prune.sh ${JOBS_LIST} ${OUTPUTS_DIR}"

JOBS_COUNT=$(cat ${JOBS_LIST} | wc -l)

sbatch --array=1-${JOBS_COUNT} ./real/scripts/prune.sh \
                               ${JOBS_LIST} \
                               ${OUTPUTS_DIR}

