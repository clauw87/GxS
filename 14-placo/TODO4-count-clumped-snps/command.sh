#!/bin/bash

rm -fR ./real/outputs/*
rm -fR ./real/tmp/*



find ../3-clump-diff/real/outputs/ -name '*.clumped' > ./real/inputs/placo-diff-results.list



# Configuration
RESULTS=./real/inputs/placo-diff-results.list
OUTPUT_DIR=./real/outputs

sbatch ./real/scripts/parse-results.sh \
       ${RESULTS} \
       ${OUTPUT_DIR}
