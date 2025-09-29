OUTPUTS_DIR=./real/outputs


cat ${OUTPUTS_DIR}/*/result.clump.loci.csv | cut -f 2,3,4,7 | head -n1 > ${OUTPUTS_DIR}/joined.clump
cat ${OUTPUTS_DIR}/*/result.clump.loci.csv | grep -v -w LEAD_SNP | cut -f 2,3,4,7 >> ${OUTPUTS_DIR}/joined.clump

#cat ${OUTPUTS_DIR}/*/result.clump.lead.csv | cut -f 2,3,4,7 | head -n1 > ${OUTPUTS_DIR}/joined.clump
#cat ${OUTPUTS_DIR}/*/result.clump.lead.csv | grep -v -w LEAD_SNP | cut -f 2,3,4,7 >> ${OUTPUTS_DIR}/joined.clump


Rscript ./real/scripts/minpleads.R ${OUTPUTS_DIR}/joined.clump ${OUTPUTS_DIR}


JOINTLEADS=${OUTPUTS_DIR}/joined.leads
REFERENCE=../../01-format/real/inputs/1000G_Phase3_EUR.tsv.gz

COMMAND="./real/scripts/clump-results.sh ${JOINTLEADS} ${REFERENCE} ${OUTPUTS_DIR}"


sbatch ${COMMAND}


