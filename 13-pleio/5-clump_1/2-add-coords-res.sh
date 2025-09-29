# Merge with 1000G to restore BP and CHR columns,
# or rather, merge with original formatted ones to also get original Z scores


# raw pleio results
RES=./real/outputs/a9f_r5f/result.clump.loci.csv

# munged sumstas
ORI=real/tmp/pleio-res.gz


COMMAND="./real/scripts/merge_res.sh $RES $ORI
"


#call from R #gzip real/tmp/pleio-res


sbatch ${COMMAND}
