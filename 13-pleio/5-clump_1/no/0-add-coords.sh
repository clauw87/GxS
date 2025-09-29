# Merge with 1000G to restore BP and CHR columns,
# or rather, merge with original formatted ones to also get original Z scores

module load R 

# pleio results file
PLEIO=
# munged sumstats
S1=
S2=

Rscript ./real/script/merge.R $PLEIO $S1 $S2
