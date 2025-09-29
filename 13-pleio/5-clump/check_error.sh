# one code that failed 2., to add coordinates

INPUTS_LIST=./real/inputs/merge_inputs_list.txt


CODE1_CODE2=r8m_r9m
RES=$(cat "${INPUTS_LIST}" | grep ${CODE1_CODE2})
ORI_FOLDER=./real/tmp


module load R


Rscript ./real/scripts/results_format.R $RES $ORI


# No error, so it was either a problem with the slurm jobs ids or memory


# Now, recheck
cat real/outputs/*/result.clump.loci.csv > check

#cat check 
cat check  | grep locu  > check.header

cat check.header | cut -f 20 | sort -u

# OK looks like all is annotated now
