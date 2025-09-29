OUTPUTS_DIR=./real/outputs
rm -rf ./real/outputs/*



module load R


#METADATA=../03-power-calc/real/outputs/joined_metadata_power.txt


H2_FILE=../../03-power-calc/real/outputs/h2_liab.txt
POWERED_FILE=../2-join_h2_results/real/outputs/h2_powered_2.txt

cat ${POWERED_FILE} | grep -v em_ | grep -v ef_ > ./real/inputs/target.txt

TARGET=./real/inputs/target.txt

Rscript ./real/scripts/compare_h2.R ${H2_FILE} ${TARGET} ${OUTPUTS_DIR}


Rscript ./real/scripts/h2_plot_table.R ./real/outputs/compare_h2_liab_scale.txt
