#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J repeated
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 0-16:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


SHARED_PLEIOS=($(cat ../2-compare-m-f/real/outputs/*/shared_pleios.txt | cut -f1 | grep -v SNP | sort -u )) 
#SHARED_DIS=($(cat ../2-compare-m-f/real/outputs/*/shared_pleios_dis.txt ))
# SHARED_CON=($(cat ../2-compare-m-f/real/outputs/*/shared_pleios_con.txt ))


echo SNP times_con times_dis > repeated_shared_SNPs.txt

for S in ${SHARED_PLEIOS[@]}
do 
echo $S $(cat ../2-compare-m-f/real/outputs/*/shared_pleios_con.txt | grep -w ${S} | cut -f1 | grep -v SNP | wc -l) $(cat ../2-compare-m-f/real/outputs/*/shared_pleios_dis.txt | grep -w ${S} | cut -f1 | grep -v SNP | wc -l) >> repeated_shared_SNPs.txt
done
