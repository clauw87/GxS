
RES=../3-join_rg_results/real/outputs/formatted_rg_res.txt


#module load R 
#module load  R/4.2.0-foss-2021b



COMMAND="./real/scripts/job.sh ${RES}"

sbatch ${COMMAND}


#Rscript ./real/scripts/crosstrait_diff.R  ${RES}
#Rscript ./real/scripts/rg-diff1-barplot.R
