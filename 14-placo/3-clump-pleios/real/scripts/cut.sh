#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J cut
#SBATCH --mem 120G # memory pool for all cores  (failed with 120 for example with 5)
#SBATCH -t 0-06:00 # time (D-HH:MM)
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

#CODE=$(basename ${FILE}  | sed 's/.coord.txt.gz//g')

CODE=$(basename ${FILE}  | sed 's/.placo//g')


#zcat ${FILE} | cut -f1,2,3,4,5,26 > ${OUTDIR}/${CODE}.cut

cat $FILE | head -n1 | cut -f1,2,3,4,5,6,15,16,18 | sed 's/\.//g' > ${OUTDIR}/${CODE}
cat $FILE | tail -n+2 | cut -f1,2,3,4,5,6,15,16,18  >> ${OUTDIR}/${CODE} 
gzip ${OUTDIR}/${CODE}


