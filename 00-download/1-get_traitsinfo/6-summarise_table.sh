module load R

JOINED=real/outputs/joined_metadata.txt 

Rscript ./real/scripts/summarise_gxs.R ${JOINED}
