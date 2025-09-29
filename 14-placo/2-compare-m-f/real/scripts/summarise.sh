#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J summarise
#SBATCH --mem 16G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address



#
RES=$(ls real/outputs/*/m_f.txt)


#yes | rm ./real/outputs/differential.txt
#yes | rm ./real/outputs/diff_discordant.txt
#yes | rm ./real/outputs/discordant.txt


for RE in ${RES}
do

DIFF=$(cat ${RE} | grep DIFFERENTIAL | wc -l) 
DIS=$(cat ${RE} | grep DISCORDANT | wc -l) 
DIFF_DISCORDANT=$(cat ${RE} | grep DIFFERENTIAL | grep DISCORDANT | wc -l) 
CODE=$(echo $RE | cut -d'/' -f3)


if [ $DIFF -gt 0 ]
then
echo ${CODE} ${DIFF} >> ./real/outputs/differential.txt
fi


#yes | rm diff_discordant.txt
if [ ${DIFF_DISCORDANT} -gt 0 ]
then
echo ${CODE} ${DIFF_DISCORDANT} >> ./real/outputs/diff_discordant.txt
fi


#yes | rm discordant.txt
if [ $DIS -gt 0 ]
then
echo ${CODE} ${DIS} >> ./real/outputs/discordant.txt
fi


done 
