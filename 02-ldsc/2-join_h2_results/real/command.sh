#!/bin/bash

# Main Code --------------------------------------------------------

main(){

  # CONFIG
  OUTPUT_FILE=./real/outputs/genetic-correlations.txt

  # Extracts information from log files
  echo -e 'Trait\tIntercept\tIntercept_SE\tGC\tGC_SE\tPValue' > ${OUTPUT_FILE}
  for FILE in ../3-rg/real/outputs/*-genetic-correlation.log
  do
    TRAIT1=$(basename ${FILE} | cut -d'.' -f1)
    TRAIT2=$(basename ${FILE} | cut -d'.' -f2 | cut -d '-' -f1)
    INTERCEPT_LINE=$(cat ${FILE} | grep -i -A 6 'Heritability of phenotype 2/2' | grep -i intercept)
    INTERCEPT=$(echo ${INTERCEPT_LINE} | cut -d" " -f2)
    INTERCEPT_SE=$(echo ${INTERCEPT_LINE} | cut -d" " -f3 | tr -d "(" | tr -d ")")

    GC_LINE=$(cat ${FILE} |  grep -A 4 -i 'genetic correlation$' | grep -i 'genetic correlation:')
    GC=$(echo ${GC_LINE} | cut -d" " -f3 )
    GC_SE=$(echo ${GC_LINE} | cut -d" " -f4 | tr -d "(" | tr -d ")")

    P_LINE=$(cat ${FILE} |  grep -A 4 -i 'genetic correlation$' | grep -i 'P:')
    P=$(echo ${P_LINE} | cut -d":" -f2 )

    echo -e "${TRAIT1}\t${TRAIT2}\t${INTERCEPT}\t${INTERCEPT_SE}\t${GC}\t${GC_SE}\t${P}" >> ${OUTPUT_FILE}

  done

}



# FUNCTIONS ==========================================================

main
