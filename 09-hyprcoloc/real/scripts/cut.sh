#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J cut
#SBATCH --mem 120G # memory pool for all cores  (failed with 120 for example with 5)
#SBATCH -t 1-16:00 # time (D-HH:MM)
#SBATCH -o ./real/tmp/log.%j.out # STDOUT
#SBATCH -e ./real/tmp/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


ARRAY_LIST=$1
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
  FILE=$(cat ${ARRAY_LIST} | sed -n 1p )
else
  #CODE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
  FILE=$(cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi


CODE=$(basename ${FILE}  | sed 's/.coloc-munged-sumstats.gz//g')

 
zcat $FILE | head -n1 | cut -f3,6 | sed 's/\.//g' > ${OUTDIR}/${CODE}.betas
zcat $FILE | grep -v -w SNP  | cut -f3,6  >> ${OUTDIR}/${CODE}.betas 
#gzip ${OUTDIR}/${CODE}.betas

zcat $FILE | head -n1 | cut -f3,7 | sed 's/\.//g' > ${OUTDIR}/${CODE}.ses
zcat $FILE | grep -v -w SNP  | cut -f3,7  >> ${OUTDIR}/${CODE}.ses
#gzip ${OUTDIR}/${CODE}.ses



