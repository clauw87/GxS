module load R

# create joined_metadata
# neales icd10 : 8 traits

Rscript real/scripts/harmonise_join.R atlas elenas requested neales_icd10

# remove similar traits
Rscript ./real/scripts/remove.R
