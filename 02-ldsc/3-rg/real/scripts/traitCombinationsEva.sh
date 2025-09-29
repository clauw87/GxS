#!/bin/bash
#

INPUT_PATH=../../01-MungeSumStats/outputs/*.munged-sumstats.gz
OUTPUT_DIR=../inputs/traitCombinations.txt

echo $INPUT_PATH

python3 ./traitCombinations.py $OUTPUT_DIR \
                               ${INPUT_PATH[@]}
