#!/bin/bash
#



LDCS_DIR=../ldsc

SUMSTATS_LS=../munge/output/*.sumstats.gz
SUMSTATS_FOLDER=../munge/output/

OUTPUT_DIR=./output


#REF_TRAIT=../munge/output/.txt.gz.sumstats.gz


# prepare combinations of phenotypes from munged sumstats folder 

awk -f combinations.awk <<< $(ls $SUMSTATS_LS) > ./combinations


#list of pairs with self 

s=(`ls $SUMSTATS_LS`)
for s in ${s[@]}
do
echo "doing self pair $s $s"

OUTFILE="$(basename -- $s)_$(basename -- "$s")"

python ${LDCS_DIR}/ldsc.py \
    --ref-ld-chr ${LDCS_DIR}/eur_w_ld_chr/ \
    --out ${OUTPUT_DIR}/${OUTFILE} \
    --rg $s,$s \
    --w-ld-chr ${LDCS_DIR}/eur_w_ld_chr/ \

done


#combinations of pairs of traits

c=./combinations

nrow=`cat $c | wc -l`

#for n rows in combinations file take each column as a pheno for bivariate test

for i in $(seq 1 1 $nrow)
do
r=(`sed -n "${i}p" < $c`)
echo "doing pair ${r[@]}"


OUTFILE="$(basename -- ${r[0]})_$(basename -- "${r[1]}")"

echo "printing in ${OUTPUT_DIR}$OUTFILE"

python ${LDCS_DIR}/ldsc.py \
    --ref-ld-chr ${LDCS_DIR}/eur_w_ld_chr/ \
    --out ${OUTPUT_DIR}/${OUTFILE} \
    --rg ${r[0]},${r[1]} \
    --w-ld-chr ${LDCS_DIR}/eur_w_ld_chr/ \

done
