#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J tab
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 0-00:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/messages.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/messages.log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


RES_DIR=$1
TMP_DIR=$2


module load R/3.2.3

# RES_DIR=../1-run-clumped/real/outputs
# TMP_DIR=./real/tmp



#Rscript real/scripts/check_results2.R ${TMP_DIR} ${RES_DIR}
#exit



echo pair num_placo num_coloc num_same_causal num_distinct_causal > ${TMP_DIR}/restable.txt

for RESO in $(ls ${RES_DIR}/coloc_*.txt)
# ../1-run-clumped/real/outputs/coloc_*.txt
do
CODE=$(echo $RESO | xargs -I {} basename {} | sed 's/coloc_//g' | cut -d '.' -f1)
# create column 33 for pp4 + pp3
# create column 34 for pp4/pp3
#cat ${RESO} | awk '{ print $0, $12+ $11}' > ${TMP_DIR}/${CODE}.tmp
cat ${RESO} | awk 'NR==1 { print $0 " sum"; next} {result =  $12 + $11; print $0, result }' | tr '\t' ' ' > ${TMP_DIR}/${CODE}.tmp 
cat ${TMP_DIR}/${CODE}.tmp | awk 'NR==1 { print $0 " div"; next} {result = ($11 != 0) ? $12 / $11 : "NA"; print $0, result }' | tr '\t' ' ' > ${TMP_DIR}/${CODE}.tmp2
RES=${TMP_DIR}/${CODE}.tmp2
echo $(echo $CODE) $(cat ${RES} | tail -n+2 | wc -l) $(cat ${RES} | awk '{ if ($33>=0.9) print $0}' | grep -v -w snp | wc -l) $(cat ${RES} | awk '{ if ($33>=0.9 && $34>=3) print $0}' | grep -v -w snp | wc -l )   $(cat ${RES} | awk '{ if ($33>=0.9 && $34<3) print $0}' | grep -v -w snp | wc -l ) >>  ${TMP_DIR}/restable.txt
cat $RES | head -n1 > ${TMP_DIR}/${CODE}.distinctcausal.loci
cat $RES | awk '{ if ( $33>=0.9 && $34<3 ) print $0}' | grep -v -w snp  >> ${TMP_DIR}/${CODE}.distinctcausal.loci
cat $RES | head	-n1 > ./real/tmp/${CODE}.samecausal.loci
cat $RES | awk '{ if ( $32>=0.9 && $33>=3 ) print $0}'  | grep -v -w snp  >> ${TMP_DIR}/${CODE}.samecausal.loci

done



Rscript real/scripts/check_results2.R ${TMP_DIR} ${RES_DIR}
