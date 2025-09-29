#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J gw-sig
#SBATCH --mem 16G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


#RES=$(ls real/outputs/*.m_f.shared.5e-08.txt)
# real/outputs/a9m_r5m:a9f_r5f.m_f.shared.5e-08.txt


RES=$(ls real/outputs/*/shared_pleios_gw.txt)

# overall
#cat real/outputs/*.shared_pleios_gw_txt |  grep CONCOR | cut -f1 | sort -u | wc -l   # 8032
#cat real/outputs/*.shared_pleios_gw.txt  | grep DISCOR | cut -f1 | sort -u | wc -l   # 1096


echo CODE SHARED_GW CON DIS> ./real/outputs/shared_gw_summary.txt


for RE in ${RES}

do

# save 
cat ${RE} | grep -w SHARED_GW | grep -w GW_f |  grep -w GW_m  >> ./real/outputs/shared_gw.txt

GWSHARED=$(cat ${RE} | grep -v -w SNP |  wc -l)
GWSHAREDCON=$(cat ${RE} | grep -v -w SNP  | grep -w CONCORDANT | wc -l)
GWSHAREDDIS=$(cat ${RE} | grep -v -w SNP  | grep -w DISCORDANT | wc -l)


CODE=$(echo $RE | cut -d'/' -f3)

echo ${CODE} ${GWSHARED} ${GWSHAREDCON} ${GWSHAREDDIS} >> ./real/outputs/shared_gw_summary.txt

done


