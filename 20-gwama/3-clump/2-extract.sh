#!/bin/bash

#rm -fR ./real/outputs/*
#rm -fR ./real/tmp/*



#find real/outputs/ -name '*.clumped' > ./real/inputs/clumped-results.list
find real/outputs/ -name '*.clump.indep.csv' > ./real/inputs/clumped-indep.list
find real/outputs/ -name '*.clump.loci.csv' >  ./real/inputs/clumped-loci.list


#exit


# Configuration

INDEP_LIST=./real/inputs/clumped-indep.list
LOCI_LIST=./real/inputs/clumped-loci.list

OUTPUT_DIR=./real/outputs


COMMAND="  \
./real/scripts/parse-results.sh \
       ${INDEP_LIST} \
       ${LOCI_LIST} \
       ${OUTPUT_DIR}
"

# Array execution
JOBS_COUNT=$(cat ${LOCI_LIST} | wc -l)
eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}


#sbatch ./real/scripts/parse-results.sh \
 #      ${INDEP} \
 #      ${LOCI} \
 #      ${OUTPUT_DIR}
