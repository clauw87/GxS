
RES=../3-join_rg_results/real/outputs/mf_shared_sig.txt


#module load R 
module load  R/4.2.0-foss-2021b


Rscript ./real/scripts/intratrait_diff.R  ${RES}


Rscript ./real/scripts/rg-diff1-barplot.R
