#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J join
#SBATCH --mem 16G # memory pool for all cores
#SBATCH -t 0-00:29 # time (D-HH:MM)
#SBATCH -o ./real/outputs/job2.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/job2.log.%j.err # STDERR







TMP_DIR=$1
OUT_FILE=$2


# failed ones grep -f  ./real/inputs/failed.codes.txt 
find $( readlink -f ${TMP_DIR}/) -iname '*.gz'  > ${OUT_FILE}

