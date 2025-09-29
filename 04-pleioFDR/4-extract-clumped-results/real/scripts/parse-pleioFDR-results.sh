#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J parse-pleioFDR
#SBATCH --mem 64G # memory pool for all cores
#SBATCH -t 0-23:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load Python/3.6.6-foss-2018b

# Config
RESULTS=$1
OUTPUT_DIR=$2
OUTPUT_FILE=${OUTPUT_DIR}/all-vs-all-pleioFDR-pleiotropies.list
rm -rf ${OUTPUT_FILE}

echo "CODE,TOTAL,POS,NEG" > ${OUTPUT_FILE}
for RESULT in $(cat ${RESULTS})
do
  CODE=$(echo ${RESULT} | cut -d'/' -f5)
  LOCI=../3-clump-pleioDFR-results/real/outputs/${CODE}/result.clump.indep.csv
  read -r TOTAL POS NEG < <(python ./real/scripts/parse-pleioFDR-results.py ${RESULT} ${LOCI})
  echo "${CODE},${TOTAL},${POS},${NEG}" >> ${OUTPUT_FILE}
done



