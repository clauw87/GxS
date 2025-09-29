#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J create-pvals-file
#SBATCH --mem 20G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules


# Config
FILE=$1
CODE=$2
OUTPUT_DIR=$3

OUTPUTDIR=$OUTPUT_DIR/$CODE


#CODE=$(basename ${FILE} | cut -d '.' -f1)

# Create PVAL file

#zcat ${FILE} > ./real/tmp/${CODE}_pvals
#awk -v cols='SNP,t-pval' 'BEGIN{FS=OFS=" "; nc=split(cols, a, ",")} NR==1{for (i=1; i<=NF; i++) hdr[$i]=i} {for (i=1; i<=nc; i++) if (a[i] in hdr) printf "%s%s", $hdr[a[i]], (i<nc?OFS:ORS)}' ./real/tmp/${CODE}_pvals > ${OUTPUT_DIR}/${CODE}.pvals
#rm ./real/tmp/${CODE}_pvals




#zcat ${FILE} | awk '{ if  ($9 >0) print $0 }' | cut -f3,9 | tr '\t' ' ' > ${OUTPUT_DIR}/${CODE}.pvals


echo SNP pleiop | tr '\t' ' ' > ${OUTPUT_DIR}/${CODE}.pvals

#cat ../../../7-pleio-m-f-compare/real/outputs/a9_r5/pleioc_loci.txt  |  awk '{ if  ($23 == "DISCORDANT") print $0 }' | cut -f1,7 | tr '\t' ' ' >> ${OUTPUT_DIR}/${CODE}.pvals


 cat ${FILE} |  awk '{ if  ($23 == "DISCORDANT") print $0 }' | cut -f1,7 | tr '\t' ' ' >> ${OUTPUT_DIR}/${CODE}.pvals
#discordant only are too few, less than three can no be analysed in geneset


#cat ${FILE} |  cut -f1,7 | tr '\t' ' ' >> ${OUTPUT_DIR}/${CODE}.pvals
