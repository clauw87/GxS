#!/bin/bash

function report(){
  # Echo function to follow the flow the pipeline
  echo
  echo
  echo '-------------------------------------------' $(date)
  echo '-----------------------------------------------------------------'___$1
  echo
  echo

}

for SUMSTAT_FILE in $(cat  ./real/inputs/sumstats.list)
do
    TRAIT=$(basename ${SUMSTAT_FILE} | cut -d'.' -f1)
    SNPS_COUNT=$(zcat ${SUMSTAT_FILE}| grep -v SNP | awk '$2 != ""{print $0}' | wc -l)
    echo -e "${TRAIT}\t${SNPS_COUNT}"  >> ./real/outputs/snpcounts.txt
done
report "all tasks finished"
  
