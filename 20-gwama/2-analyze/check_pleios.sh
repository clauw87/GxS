#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J checkpleios
#SBATCH --mem 64G
#SBATCH -t 0-03:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR


RES_LS=$(ls real/outputs/*.sex_diff_iii | grep -v ef_ | grep -v em_ )


# Pooled sex-biased SNPs ------------------------------------------------------------------

echo CODE SNP CHR BP A1 A2 effects Zm Zf diffpval > ./real/outputs/pooled.sbsnps.tab
for RES in $RES_LS
do
CODE=$(echo $RES | xargs -I {} basename {}  | cut -d '.' -f1) 
cat $RES | tr '\t' ' ' > ./real/tmp/${CODE}.sbsnps.tmp
LINES=./real/tmp/${CODE}.sbsnps.tmp
paste -d' ' <(yes $CODE | head -n $(wc -l < $LINES )) $LINES >> ./real/outputs/pooled.sbsnps.tab
done

cat ./real/outputs/pooled.sbsnps.tab | cut -d ' ' -f2 | grep -v -w SNP | sort -u >> ./real/outputs/pooled.sbsnps

# --------------------------------------------------------------------------------------------
# Repeated - sex biased in more than one trait - counts of number for traits and number of different domains

cat ${RES_LS} | grep -v -w SNP | cut -f1 > ./real/outputs/all.sbsnps
Rscript ./real/scripts/getrep.R  ./real/outputs/all.sbsnps
REP=./real/outputs/repeated.gwama.sbsnps


# table with repeated only
cat ./real/outputs/pooled.sbsnps | head -n1 > ./real/outputs/pooled.repeated.sbsnps
cat ./real/outputs/pooled.sbsnps | grep -w -f  ${REP} >> ./real/outputs/pooled.repeated.sbsnps
