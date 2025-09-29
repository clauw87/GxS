#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J parse-betadiff
#SBATCH --mem 30G # memory pool for all cores
#SBATCH -t 0-23:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load Python/3.6.6-foss-2018b

# Config
INDEP_LIST=$1
LOCI_LIST=$2
OUTPUT_DIR=$3

#OUTPUT_FILE=${OUTPUT_DIR}/loci.list



# Cluster Array
INDEP=$(cat "${INDEP_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)

#LOCI=$(cat "${LOCI_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)



#echo "CODE,TOTAL,POS,NEG" > ${OUTPUT_FILE}

#for RESULTS in $(cat ${RESULTS})
#do
  CODE=$(echo ${INDEP} | cut -d'/' -f3)
  LOCI=$(cat "${LOCI_LIST}" | grep ${CODE})

  OUTPUT_FILE=${OUTPUT_DIR}/${CODE}/loci.list

  echo "CODE,TOTAL,POS,NEG" > ${OUTPUT_FILE}
  read -r TOTAL POS NEG < <(python ./real/scripts/parse-results.py ${INDEP} ${LOCI} ${CODE})
  echo "${CODE},${TOTAL},${POS},${NEG}" >> ${OUTPUT_FILE}
#done
