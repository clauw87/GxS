

cat real/outputs/*.sig.genes | grep -v SYMBOL > ./real/tmp/all.sig.genes

RES_FILE=./real/tmp/all.sig.genes
OUTPUT_DIR=./real/outputs


Rscript ./real/scripts/counttimes.R ${RES_FILE} ${OUTPUT_DIR}
