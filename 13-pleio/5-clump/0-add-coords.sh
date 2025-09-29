#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
   rm -fR ./real/outputs/*
   rm -fR ./real/tmp/* 
   rm -fR real/inputs/*
  
# Configuration


# Merge with 1000G to restore BP and CHR columns,
# or rather, merge with original formatted ones to also get original Z scores

# code or list of codes

list=$(ls -d ../4-run/real/outputs/*/ )

for l in $list
do
basename $l >>  ./real/inputs/input_list.txt
done

#exit

INPUT_LIST=./real/inputs/input_list.txt
OUT=./real/outputs

# Per code
# raw pleio results
#PLEIO=../3-run/real/outputs/pleio.txt.gz
# munged sumstas
#S1=../2-munge/real/outputs/a9m.gz
#S2=../2-munge/real/outputs/r5m.gz



COMMAND="./real/scripts/merge.sh $INPUT_LIST $OUT
"

  # Execution 
 

  # Cluster array execution
  JOBS_COUNT=$(cat ${INPUT_LIST} | wc -l)
  eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit

  # Direct execution
  #eval bash ${COMMAND}
  #exit 

  # Cluster execution
  #eval sbatch ${COMMAND}
  #exit             

} 


# FUNCTIONS ==========================================================

main
