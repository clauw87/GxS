#!/bin/bash

rm -fR ./real/outputs/*
rm -fR ./real/tmp/*



find ../3-clump-pleioDFR-results/real/outputs/ -name '*.clumped' > ./real/inputs/pleioFDR-results.list

#find ../3-clump-pleioDFR-results/real/outputs/ -name '*.result.clump.indep.csv'


# Configuration
PLEIOFDR_RESULTS=./real/inputs/pleioFDR-results.list
OUTPUTS_DIR=./real/outputs

sbatch ./real/scripts/parse-pleioFDR-results.sh \
       ${PLEIOFDR_RESULTS} \
       ${OUTPUTS_DIR}
