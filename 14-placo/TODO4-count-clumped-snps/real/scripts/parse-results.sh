#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J parse-pleioFDR
#SBATCH --mem 30G # memory pool for all cores
#SBATCH -t 0-23:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load Python/3.6.6-foss-2018b

# Config
RESFILE=$1
OUTDITR=$2
OUTFILE=${OUTDIR}/summary.list

#echo "CODE,TOTAL,POS,NEG" > ${OUTPUT_FILE}
for RESULTS in $(cat ${RESFILE})
do
  CODE=$(echo ${RESULTS} | cut -d'/' -f5)
  #read -r TOTAL POS NEG < <(python ./real/scripts/parse-results.py ${RESULTS})
  #echo "${CODE},${TOTAL},${POS},${NEG}" >> ${OUTPUT_FILE}
  echo ${CODE},${SHARED},${CONCORDANT},${DISCORDANT}
done
