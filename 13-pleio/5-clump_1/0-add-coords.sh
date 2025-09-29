# Merge with 1000G to restore BP and CHR columns,
# or rather, merge with original formatted ones to also get original Z scores


# raw pleio results
PLEIO=../3-run/real/outputs/pleio.txt.gz

# munged sumstas
S1=../2-munge/real/outputs/a9f.gz
S2=../2-munge/real/outputs/r5f.gz

COMMAND="./real/scripts/merge.sh $PLEIO $S1 $S2
"


#call from R #gzip real/tmp/pleio-res


sbatch ${COMMAND}
