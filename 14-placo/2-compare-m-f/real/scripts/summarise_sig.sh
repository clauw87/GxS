#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J summarise-sig
#SBATCH --mem 16G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


RES=$(ls real/outputs/*/m_f.txt)

echo CODE MALE FEMALE > ./real/outputs/significant_fdr.txt
#echo CODE MALE FEMALE > ./real/outputs/significant_shared_gw.txt

for RE in ${RES}
do

SIGMALE=$(cat ${RE} | grep -w MALE | wc -l)
SIGFEMALE=$(cat ${RE} | grep -w FEMALE | wc -l)

#GWSHARED=$(cat ${RE} | grep -w SHARED | grep -w GW | grep -v -w not | wc -l)
#GWSHARED=$(cat ${RE} | grep -w SHARED | grep -w GW | grep -v -w not | wc -l)
#GWSHARED=$(cat ${RE} | grep -w SHARED | grep -w GW | grep -v -w not | wc -l)


CODE=$(echo $RE | cut -d'/' -f3)

echo ${CODE} ${SIGMALE} ${SIGFEMALE} >> ./real/outputs/significant_fdr.txt

done


