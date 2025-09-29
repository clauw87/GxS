INFO=real/outputs/joined_metadata.txt
OUT=real/outputs/joined_metadata_domains.txt

Rscript ./real/scripts/add_domains.R ${INFO} ${OUT}
