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
INFILE=$1
INCODE=$2
TMPDIR=$3
OUTDIR=$4



# Create PVAL file
#cat ${FILE} |  cut  -f1,22  > ${TMPDIR}/${CODE}_pvals
#awk -v cols='SNP,t-pval' 'BEGIN{FS=OFS=" "; nc=split(cols, a, ",")} NR==1{for (i=1; i<=NF; i++) hdr[$i]=i} {for (i=1; i<=nc; i++) if (a[i] in hdr) printf "%s%s", $hdr[a[i]], (i<nc?OFS:ORS)}' ${TMPDIR}/${CODE}_pvals > ${OUTDIR}/${CODE}.pvals
#rm ./real/tmp/${CODE}_pvals


echo SNP SEXDIFFP NMIN > ${OUTDIR}/${INCODE}.pvals 
cat ${INFILE} | awk '{ if  ($49 >0) print $0 }' | cut -f1,49,51 | tail -n +2 | tr '\t' ' ' >> ${OUTDIR}/${INCODE}.pvals



