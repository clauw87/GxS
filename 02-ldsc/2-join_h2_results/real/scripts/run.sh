#!/bin/bash
#SBATCH --partition=haswell
#SBATCH --job-name=h2_res_join
#SBATCH --output=./real/outputs/out.out
#SBATCH --error=./real/outputs/err.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16GB
# mail alert at start, end and abortion of execution
#SBATCH --mail-type=END
#SBATCH --mail-user=claudia.vasallo@upf.edu




# CONFIG
H2_OUTPUTS_FOLDER=$1
META_FILE=$2
OUTPUT_FILE=$3

module purge
module load modulepath/haswell
module load R/4.3.2-gfbf-2023a


main(){
  # Extracts information from log files
  echo -e 'Trait\tIntercept\tIntercept_SE\tRatio\tRatio_SE\tH2\tH2_SE' > ${OUTPUT_FILE}
  for FILE in ${H2_OUTPUTS_FOLDER}/*-h2.log
  do
    TRAIT=$(basename ${FILE} | sed s/-h2.log//g)
    INTERCEPT_LINE=$(cat ${FILE} | grep "Intercept:")
    INTERCEPT=$(echo ${INTERCEPT_LINE} | cut -d" " -f2)
    INTERCEPT_SE=$(echo ${INTERCEPT_LINE} | cut -d" " -f3 | tr -d "(" | tr -d ")")
    RATIO_LINE=$(cat ${FILE} | grep "Ratio:")
    RATIO=$(echo ${RATIO_LINE} | cut -d" " -f2)
    RATIO_SE=$(echo ${RATIO_LINE} | cut -d" " -f3 | tr -d "(" | tr -d ")")
    H2_LINE=$(cat ${FILE} |  grep "Total Observed scale h2:")
    H2=$(echo ${H2_LINE} | cut -d ":" -f2 | cut -d ' ' -f2 )
    H2_SE=$(echo ${H2_LINE} | cut -d ":" -f2 | cut -d ' ' -f3 | tr -d "(" | tr -d ")" )
    echo -e "${TRAIT}\t${INTERCEPT}\t${INTERCEPT_SE}\t${RATIO}\t${RATIO_SE}\t${H2}\t${H2_SE}" >> ${OUTPUT_FILE}
  done


Rscript ./real/scripts/filter_h2.R ${OUTPUT_FILE} ${META_FILE}

}

main







