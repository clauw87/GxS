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
INPUT_DIR=$2
OUTPUT_DIR=$3
TYPE=$4

OUTPUT_FILE=${OUTPUT_DIR}/all-vs-all-placo-${TYPE}-pleiotropies.list

SIG_THR=0.00000005


# resultsFile='../3-clump-pleios-shared-dis/real/outputs/l3m:l5m/l3m:l5m.0.00000005.result.clump.snps.csv'
# indepFile='../3-clump-pleios-shared-dis/real/outputs/l3m:l5m/l3m:l5m.0.00000005.result.clump.indep.csv'
# lociFile='../3-clump-pleios-shared-dis/real/outputs/l3m:l5m/l3m:l5m.0.00000005.result.clump.loci.csv'


echo "CODE,TOTAL,POS,NEG" > ${OUTPUT_FILE}
for RESULT in $(cat ${RESULTS})
do
  CODE=$(echo ${RESULT} | cut -d'/' -f5 | sed 's/.${SIG_THR}.result.clump.indep.csv//g')
  #CODE=$(echo ${RESULT} | cut -d'/' -f5 | cut -d '.' -f1)
  INDEP=${INPUT_DIR}/${CODE}/${CODE}.${SIG_THR}.result.clump.indep.csv
  LOCI=${INPUT_DIR}/${CODE}/${CODE}.${SIG_THR}.result.clump.loci.csv 
  read -r TOTAL POS NEG < <(python ./real/scripts/parse-placo-clump-results.py ${RESULT} ${INDEP} ${LOCI})
  echo "${CODE},${TOTAL},${POS},${NEG}" >> ${OUTPUT_FILE}
done



