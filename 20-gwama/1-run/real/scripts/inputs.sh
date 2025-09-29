#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J join
#SBATCH --mem 16G # memory pool for all cores
#SBATCH -t 0-00:29 # time (D-HH:MM)
#SBATCH -o ./real/outputs/job2.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/job2.log.%j.err # STDERR







SUMSTATS_FOLDER=$1
SUX=$2
PAIRS_SID=$3
OUT_FILE=$4


# failed ones grep -f  ./real/inputs/failed.codes.txt 
#find $( readlink -f ${TMP_DIR}/) -iname '*.gz'  > ${OUT_FILE}

echo '' > ./real/tmp/TMPFILE

for R in $(seq 1 $(cat ${PAIRS_SID} | wc -l))
do
echo ${R}
CODE1=$(cat  ${PAIRS_SID} | sed -n ${R}p | cut -d' ' -f1 )
CODE2=$(cat  ${PAIRS_SID} | sed -n ${R}p | cut -d' ' -f2 )
# male first
echo ${SUMSTATS_FOLDER}/${CODE1}${SUX} ${SUMSTATS_FOLDER}/${CODE2}${SUX} >> ./real/tmp/TMPFILE
done

cat ./real/tmp/TMPFILE | tail -n+2 | tr ' ' '\t'  > ./real/tmp/TMPFILE_

yes | mv ./real/tmp/TMPFILE_  ${OUT_FILE}	
