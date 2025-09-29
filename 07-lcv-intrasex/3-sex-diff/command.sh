RES_FILE=../2-format/real/outputs/results.table
META_FILE=../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt
POWER_FILE=../../02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt

module load R 

Rscript ./real/scripts/compare_lcv.R ${RES_FILE} ${META_FILE} ${POWER_FILE}
