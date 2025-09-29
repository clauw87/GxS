OUTPUTS_DIR=./real/outputs

LEADS=$(ls ${OUTPUTS_DIR}/*/*result.clump.lead.csv | grep -v joined)



H0=$(cat ${OUTPUTS_DIR}/*/*result.clump.lead.csv | cut -f 2,3,4,7 | head -n1 | tr '\t' ' ')
echo $H0 CODE > ${OUTPUTS_DIR}/joined.clump


for L in ${LEADS[@]}
do
LC=$(basename $L | cut -d '.' -f1)
cat ${OUTPUTS_DIR}/${LC}/${LC}.0.00000005.result.clump.lead.csv | grep -v -w LEAD_SNP | cut -f 2,3,4,7 | tr '\t' ' ' > ./real/tmp/${LC}.linestmp

sed -i "s/$/ $LC/" ./real/tmp/${LC}.linestmp
LINES=./real/tmp/${LC}.linestmp
cat $LINES  >>  ${OUTPUTS_DIR}/joined.clump

done


exit 


Rscript ./real/scripts/minpleads.R ${OUTPUTS_DIR}/joined.clump ${OUTPUTS_DIR}


JOINTLEADS=${OUTPUTS_DIR}/joined.leads
REFERENCE=../../01-format/real/inputs/1000G_Phase3_EUR.tsv.gz


COMMAND="./real/scripts/clump-results.sh ${JOINTLEADS} ${REFERENCE} ${OUTPUTS_DIR}"


sbatch ${COMMAND}


