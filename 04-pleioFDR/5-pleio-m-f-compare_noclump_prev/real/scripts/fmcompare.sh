#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J compare
#SBATCH --mem 120G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address





module load R/3.5.1-foss-2018b



# Config
INPUTS=$1
OUTDIR=$2


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  INPUT=$(cat "${INPUTS}" | sed -n 1p)
else
  INPUT=$(cat "${INPUTS}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 



# pleio clumped results files to compare, code list
mpair=$(echo $INPUT | cut -d ' ' -f1)
fpair=$(echo $INPUT | cut -d ' ' -f2)




#zcat ../4-run/real/outputs/${fpair}/pleio.txt.gz |  awk '{ if ($5 < 0.00000005) print $1}' > ./real/tmp/${fpair}_f_snps.txt
#zcat ../4-run/real/outputs/${mpair}/pleio.txt.gz |  awk '{ if ($5 < 0.00000005) print $1}' > ./real/tmp/${mpair}_m_snps.txt

#sort  ./real/tmp/${mpair}_m_snps.txt > ./real/tmp/${mpair}_m_sorted 
#sort  ./real/tmp/${fpair}_f_snps.txt > ./real/tmp/${fpair}_f_sorted

#comm -12 ./real/tmp/${mpair}_m_sorted ./real/tmp/${fpair}_f_sorted > ./real/tmp/${mpair}_${fpair}_common_snps.txt # 419




cat ../2-run-pleioFDR/real/outputs/${mpair}/${mpair}_conjfdr_0.05_loci.csv | cut -d ',' -f2 | tail -n +2 > ./real/tmp/${mpair}_m_snps.txt
cat ../2-run-pleioFDR/real/outputs/${fpair}/${fpair}_conjfdr_0.05_loci.csv | cut -d ',' -f2 | tail -n +2 > ./real/tmp/${fpair}_f_snps.txt


sort  ./real/tmp/${mpair}_m_snps.txt > ./real/tmp/${mpair}_m_sorted 
sort  ./real/tmp/${fpair}_f_snps.txt > ./real/tmp/${fpair}_f_sorted

comm -12 ./real/tmp/${mpair}_m_sorted ./real/tmp/${fpair}_f_sorted > ./real/tmp/${mpair}_${fpair}_common_snps.txt # 419



#grep both metain. for both pairs , for those sig snps
 
# f
zcat ../../13-pleio/3-preprocess/real/outputs/${fpair}/metain.txt.gz | head -n1 > ./real/tmp/${fpair}.txt
zcat ../../13-pleio/3-preprocess/real/outputs/${fpair}/metain.txt.gz | grep -f ./real/tmp/${mpair}_${fpair}_common_snps.txt >> ./real/tmp/${fpair}.txt 


# m 
zcat ../../13-pleio/3-preprocess/real/outputs/${mpair}/metain.txt.gz | head -n1 > ./real/tmp/${mpair}.txt
zcat ../../13-pleio/3-preprocess/real/outputs/${mpair}/metain.txt.gz | grep -f ./real/tmp/${mpair}_${fpair}_common_snps.txt   >> ./real/tmp/${mpair}.txt






Rscript ./real/scripts/fmcompare.R "${mpair}" "${fpair}"




