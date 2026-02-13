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



module purge
module load modulepath/haswell
module load R/4.3.2-gfbf-2023a



RES_DIR=$1


#    RES_DIR=../real/outputs/
#    RES_DIR=../real/outputs_280125/

echo pair shared single distinct > ./real/outputs/restable.0.9.txt
for RES in $(ls ${RES_DIR}/*.segbfs.gz)
do
RESCODE=$(basename $RES | cut -d '.' -f1)
# PPA4 > 0.8 & PPA3>0.8 or PPA4 > 0.8 &  PPA3<0.5
#echo $(echo $RES | xargs -I {} basename {} | cut -d '.' -f1) $(zcat ${RES} | awk '{ if ($19>0.8) print $0}' | grep -v -w chunk | wc -l)  $(zcat ${RES} | awk '{ if ($19>0.8 && $18>0.8) print $0}' | grep -v -w chunk | wc -l)  $(zcat ${RES} | awk '{ if ($19>0.8 && $18<0.5) print $0}' | grep -v -w chunk | wc -l) >> ./real/outputs/restable.txt
#zcat ${RES} | awk '{ if ($19>0.8) print $1}' | grep -v -w chunk > ./real/outputs/$RESCODE.chunks

# PPA4 > 0.9 & PPA3 > 0.5 or not 
echo $(echo $RES | xargs -I {} basename {} | cut -d '.' -f1) $(zcat ${RES} | awk '{ if ($19>0.9) print $0}' | grep -v -w chunk | wc -l)  $(zcat ${RES} | awk '{ if ($19>0.9 && $18>0.5) print $0}' | grep -v -w chunk | wc -l)  $(zcat ${RES} | awk '{ if ($19>0.9 && $18<0.5) print $0}' | grep -v -w chunk | wc -l) >> ./real/outputs/restable.0.9.txt
zcat ${RES} | awk '{ if ($19>0.9) print $1}' | grep -v -w chunk > ./real/outputs/$RESCODE.0.9.chunks

done




#cat real/outputs/restable.txt | awk '{ if ($2 > 0 ) print $0}'  | wc -l    # 757 comparisons some pleiotropic loci in at least 1 sex
cat real/outputs/restable.0.9.txt | awk '{ if ($2 > 0 ) print $0}'  > ./real/outputs/res.0.9.txt
#cat real/outputs/restable.txt | awk '{ if ($2 > 0 ) print $0}'  > ./real/outputs/res.txt




Rscript ./real/scripts/check_results.R ./real/outputs/res.0.9.txt
