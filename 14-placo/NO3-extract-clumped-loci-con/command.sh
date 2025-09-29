#!/bin/bash

rm -fR ./real/outputs/*
rm -fR ./real/tmp/*

TYPE=con

RES=../3-clump-pleios-shared-${TYPE}/real/outputs

find ${RES}/ -name '*.result.clump.snps.csv' > ./real/inputs/placo-clumped-${TYPE}-results.list


# Configuration
PLACO_CLUMPED_RESULTS=./real/inputs/placo-clumped-${TYPE}-results.list
OUTPUTS_DIR=./real/outputs

sbatch ./real/scripts/parse-placo-clump-results.sh \
       ${PLACO_CLUMPED_RESULTS} \
       ${RES} \
       ${OUTPUTS_DIR} \
       ${TYPE}
