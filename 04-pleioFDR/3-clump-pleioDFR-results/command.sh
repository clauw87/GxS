#!/bin/bash

#rm -fR ./real/outputs/*
#rm -fR ./real/tmp/*
rm -fR ./real/tmp/pleioFDR-results.list

POWERED=../../02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt


# Configuration
find ../2-run-pleioFDR/real/outputs/ -name '*.mat' | grep -v tmp | grep -w -f ${POWERED} > ./real/inputs/pleioFDR-results.list

#cat ./real/inputs/pleioFDR-results.list | grep -f failed_codes.txt > ./real/inputs/pleioFDR-results.list_failed
#PLEIOFDR_RESULTS_LIST=./real/inputs/pleioFDR-results.list_failed

PLEIOFDR_RESULTS_LIST=./real/inputs/pleioFDR-results.list

REFERENCE_FILE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/LifespanPleiotropies_2/data/1000G-SNPs.ref.gz
OUTPUTS_DIR=./real/outputs


# Extracts codes from result files names and original result file names
for FILE in $(cat ${PLEIOFDR_RESULTS_LIST})
do
  CODE1_CODE2=$(echo ${FILE} | cut -d'/' -f5)
	
  CODE1=$(echo ${CODE1_CODE2} | cut -d ":" -f1)
  CODE2=$(echo ${CODE1_CODE2} | cut -d ":" -f2)
  echo -e ${CODE1_CODE2}"\t"${FILE}"\t../2-run-pleioFDR/real/outputs/${CODE1_CODE2}/${CODE1}_${CODE2}_zscore_conjfdr_0.05_all.csv" \
    >> ./real/tmp/pleioFDR-results.list
done

#exit


JOBS_COUNT=$(cat ${PLEIOFDR_RESULTS_LIST} | wc -l)
sbatch --array=1-${JOBS_COUNT} ./real/scripts/clump-pleioFDR-results.sh \
                               ./real/tmp/pleioFDR-results.list \
                               ${REFERENCE_FILE} \
                               ${OUTPUTS_DIR}

