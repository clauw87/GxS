#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J cmerge-0
#SBATCH --mem 120G # memory pool for all cores  (failed with 120 for example with 5)
#SBATCH -t 0-16:00 # time (D-HH:MM)
#SBATCH -o ./real/tmp/log.%j.out # STDOUT
#SBATCH -e ./real/tmp/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address



module load R/3.5.1-foss-2018b

# Config
ARRAY_LIST=$1
OUTPUTS=$2



# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  FILE=$(cat ${ARRAY_LIST} | sed -n 1p)
else
  FILE=$(cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 




# dor simple analysis - raw placo results
# FILE=../1-run-placo/real/outputs/${CODE}.placo
# CODE=$(basename ${FILE} | sed s/'.placo'//g)


#CODE=$(basename ${FILE} | sed 's/.m_f.full.txt//g')
CODE=$(basename ${FILE} | sed 's/.m_f.shared.5e-08.txt//g')


# coordinates sumstats
CODE1=$(echo ${CODE} | cut -d ':' -f1 | cut -d '_' -f1)
FORMATTED=../0-munge/real/outputs/${CODE1}.pleio-munged-sumstats.gz



Rscript ./real/scripts/merge.R ${FILE} ${FORMATTED} ${CODE} ${OUTPUTS}




