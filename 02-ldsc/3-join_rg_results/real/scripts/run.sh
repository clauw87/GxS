#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=rg_res_join
#SBATCH --output=./real/outputs/out.out
#SBATCH --error=./real/outputs/err.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=200GB
#SBATCH --mail-type=END
#SBATCH --mail-user=claudia.vasallo@upf.edu


module load R

# CONFIG
GR_OUTPUTS_FOLDER=$1
OUTPUT_FILE=./real/outputs/genetic-correlations_oob.txt


main(){
  # Extracts information from log files
  echo -e 'Trait\tIntercept\tIntercept_SE\tGC\tGC_SE\tPValue' > ${OUTPUT_FILE}
  for FILE in ${GR_OUTPUTS_FOLDER}/*-genetic-correlation.log
  do
    TRAIT1=$(basename ${FILE} | cut -d'.' -f1)
    TRAIT2=$(basename ${FILE} | cut -d'.' -f2 | cut -d '-' -f1)
    INTERCEPT_LINE=$(cat ${FILE} | grep -i -A 6 'Heritability of phenotype 2/2' | grep -i intercept)
    INTERCEPT=$(echo ${INTERCEPT_LINE} | cut -d" " -f2)
    INTERCEPT_SE=$(echo ${INTERCEPT_LINE} | cut -d" " -f3 | tr -d "(" | tr -d ")")
    cat ${FILE} | grep -A1 h2_obs_se > ./real/tmp/${TRAIT1}_${TRAIT2}
    GC_LINE=$(cat ${FILE} |  grep -A 4 -i 'genetic correlation$' | grep -i 'genetic correlation:')
    GC=$(echo ${GC_LINE} | cut -d" " -f3 )
    GC_SE=$(echo ${GC_LINE} | cut -d" " -f4 | tr -d "(" | tr -d ")")

    P_LINE=$(cat ${FILE} |  grep -A 4 -i 'genetic correlation$' | grep -i 'P:')
    P=$(echo ${P_LINE} | cut -d":" -f2 )

    echo -e "${TRAIT1}\t${TRAIT2}\t${INTERCEPT}\t${INTERCEPT_SE}\t${GC}\t${GC_SE}\t${P}" >> ${OUTPUT_FILE}

  done


}


main



Rscript ./real/scripts/rg_res.R



Rscript ./real/scripts/joinedresformat.R


#Rscript ./real/scripts/intratrait_diff.R


#Rscript	./real/scripts/crosstrait_diff.R
#Rscript ./real/scripts/heatmaps_ct.R
