#!/bin/bash

rm -fR ./real/outputs/*
rm -fR ./real/tmp/*


RES=../3-clump-pleios/real/outputs
#RES=../3-clump-pleios-shared-dis/real/outputs
#RES=../3-clump-pleios-shared-con/real/outputs

# ../3-clump-pleios-shared-dis/real/outputs/l3m:l5m/l3m:l5m.0.00000005.result.clump.snps.csv
#find ${RES}/ -name '*-result.clumped' | grep -v bernabeu | grep -v fuma > ./real/inputs/placo-clumped-results.list

find ${RES}/ -name '*.result.clump.snps.csv' > ./real/inputs/placo-clumped-results.list


# Configuration
PLACO_CLUMPED_RESULTS=./real/inputs/placo-clumped-results.list
OUTPUTS_DIR=./real/outputs

sbatch ./real/scripts/parse-placo-clump-results.sh \
       ${PLACO_CLUMPED_RESULTS} \
       ${RES} \
       ${OUTPUTS_DIR}
