# check and tabulater results


META=../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt

RES=./real/outputs/joined-loci.list



module load R
Rscript real/scripts/tex_table.R ${META} ${RES}

