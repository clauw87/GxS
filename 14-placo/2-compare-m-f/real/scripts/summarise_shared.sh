#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J summarise-shared
#SBATCH --mem 16G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address



#
#RES=$(ls real/outputs/*/m_f.txt)
RES=$(ls real/outputs/*/shared_pleios.txt)


#yes | rm ./real/outputs/differential.txt
#yes | rm ./real/outputs/diff_discordant.txt
#yes | rm ./real/outputs/discordant.txt


for RE in ${RES}
do

SHARED=$(cat ${RE} | grep SHARED | wc -l)
DIFF=$(cat ${RE} | grep SHARED | grep DIFFERENTIAL | wc -l) 
DIS=$(cat ${RE} | grep SHARED | grep DISCORDANT | wc -l) 
CON=$(cat ${RE} | grep SHARED | grep CONCORDANT | wc -l)
DIFF_DIS=$(cat ${RE} | grep SHARED | grep DIFFERENTIAL | grep DISCORDANT | wc -l) 
DIFF_CON=$(cat ${RE} | grep SHARED | grep DIFFERENTIAL | grep CONCORDANT | wc -l)

CODE=$(echo $RE | cut -d'/' -f3)



if [ $SHARED -gt 0 ]
then
echo ${CODE} ${SHARED}  >> ./real/outputs/shared.txt
fi


if [ $DIFF -gt 0 ]
then
echo ${CODE} ${DIFF} >> ./real/outputs/shared_differential.txt
fi


if [ ${DIFF_DIS} -gt 0 ]
then
echo ${CODE} ${DIFF_DIS} >> ./real/outputs/shared_diff_discordant.txt
fi


if [ ${DIFF_CON} -gt 0 ]
then
echo ${CODE} ${DIFF_CON} >> ./real/outputs/shared_diff_concordant.txt
fi



if [ $DIS -gt 0 ]
then
echo ${CODE} ${DIS} >> ./real/outputs/shared_discordant.txt
fi



if [ $CON -gt 0 ]
then
echo ${CODE} ${CON} >> ./real/outputs/shared_concordant.txt
fi


done 
