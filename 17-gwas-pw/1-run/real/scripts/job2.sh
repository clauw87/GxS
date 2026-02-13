#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J join
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 0-11:29 # time (D-HH:MM)
#SBATCH -o ./real/outputs/job2.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/job2.log.%j.err # STDERR







TMP_DIR=$1
FIL_FILE=$2
OUT_FILE=$3

# failed ones grep -f  ./real/inputs/failed.codes.txt 
#ls ${TMP_DIR}/*.gz |  grep -f  ./real/inputs/failed.codes.txt > ${OUT_FILE}



ls ${TMP_DIR}/*.gz | grep -w -f ${FIL_FILE} | grep -v clean | sort -u  > ${OUT_FILE}
