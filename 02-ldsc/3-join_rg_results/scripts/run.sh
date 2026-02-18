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


module purge
module load modulepath/haswell
module load R/4.3.2-gfbf-2023a


# CONFIG
GR_OUTPUTS_FOLDER=$1
#COMBS=$2
METAF=$2
POWERF=$3


RES_FILE_OOB=./real/outputs/genetic-correlations_oob.txt
RES_FILE=./real/outputs/genetic-correlations.txt

main(){
  # Extracts information from log files
  echo -e 'Trait\tIntercept\tIntercept_SE\tGC\tGC_SE\tPValue' > ${RES_FILE_OOB}
  echo -e 'Trait\tIntercept\tIntercept_SE\tGC\tGC_SE\tPValue' > ${RES_FILE}
  for FILE in ${GR_OUTPUTS_FOLDER}/*-genetic-correlation.log
  do
    NAME=$(echo ${FILE} | sed 's/-0.0./-0-0./g') # problematic names in Berbabeu-s ids
    TRAIT1N=$(basename ${NAME} | cut -d'.' -f1)
    TRAIT2N=$(basename ${NAME} | cut -d'.' -f2 | awk '{gsub(/-genetic-correlation/, ""); print}')
    TRAIT1=$(echo ${TRAIT1N} | sed 's/-0-0/-0.0/g')
    TRAIT2=$(echo ${TRAIT2N} | sed 's/-0-0/-0.0/g')
    INTERCEPT_LINE=$(cat ${FILE} | grep -i -A 6 'Heritability of phenotype 2/2' | grep -i intercept)
    INTERCEPT=$(echo ${INTERCEPT_LINE} | cut -d" " -f2)
    INTERCEPT_SE=$(echo ${INTERCEPT_LINE} | cut -d" " -f3 | tr -d "(" | tr -d ")")
    GC_LINE=$(cat ${FILE} |  grep -A 4 -i 'genetic correlation$' | grep -i 'genetic correlation:')
    GC=$(echo ${GC_LINE} | cut -d" " -f3 )
    GC_SE=$(echo ${GC_LINE} | cut -d" " -f4 | tr -d "(" | tr -d ")")
    P_LINE=$(cat ${FILE} |  grep -A 4 -i 'genetic correlation$' | grep -i 'P:')
    P=$(echo ${P_LINE} | cut -d":" -f2 )
    echo -e "${TRAIT1}\t${TRAIT2}\t${INTERCEPT}\t${INTERCEPT_SE}\t${GC}\t${GC_SE}\t${P}" >> ${RES_FILE_OOB}
    # By pass Out of Bonds - raw results >
    cat ${FILE} | grep -A1 h2_obs_se > ./real/tmp/${TRAIT1}:${TRAIT2}
    GC=$(cat ./real/tmp/${TRAIT1}:${TRAIT2} | tail -n+2 | awk '{print $3}')
    GC_SE=$(cat ./real/tmp/${TRAIT1}:${TRAIT2} | tail -n+2 | awk '{print $4}')
    P=$(cat ./real/tmp/${TRAIT1}:${TRAIT2} | tail -n+2 | awk '{print $6}')
    echo -e "${TRAIT1}\t${TRAIT2}\t${INTERCEPT}\t${INTERCEPT_SE}\t${GC}\t${GC_SE}\t${P}" >> ${RES_FILE}
  done


}

main


# Full table with raw results - No  Out of Bonds Warning
cat real/tmp/r9m:r9m | head -n1 > ./real/outputs/genetic-correlations-raw.txt
cat real/tmp/* | grep -v -w gcov_int >> ./real/outputs/genetic-correlations-raw.txt





###### NO Rscript ./real/scripts/rg_res.R



Rscript ./real/scripts/joinedresformat.R ${RES_FILE} ${METAF} ${POWERF}






# in their dedicated folders outside
##Rscript ./real/scripts/intratrait_diff.R
##Rscript	./real/scripts/crosstrait_diff.R
##Rscript ./real/scripts/heatmaps_ct.R
