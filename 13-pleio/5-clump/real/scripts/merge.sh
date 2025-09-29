#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J cmerge-0
#SBATCH --mem 300G # memory pool for all cores  (failed with 120 for example with 5)
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address





#module load R
module load R/3.5.1-foss-2018b

# Config
INPUTS_LIST=$1
OUTPUT_DIR=$2


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  CODE1_CODE2=$(cat "${INPUTS_LIST}" | sed -n 1p)
else
  CODE1_CODE2=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 


# no, save in TMP folder and create output folders later
#mkdir $OUTPUT_DIR/${CODE1_CODE2}


CODE1=$(echo ${CODE1_CODE2} | cut -d '_' -f1)
CODE2=$(echo ${CODE1_CODE2} | cut -d '_' -f2)




# raw pleio results
#PLEIO=../3-run/real/outputs/${CODE1_CODE2}/pleio.txt.gz

PLEIO=../4-run/real/outputs/${CODE1_CODE2}/pleio.txt.gz


# munged sumstas
#S1=../2-munge/real/outputs/a9m.gz
S1=../2-munge/real/outputs/${CODE1}.gz
S2=../2-munge/real/outputs/${CODE2}.gz


# pleio results file


Rscript ./real/scripts/merge.R $PLEIO $S1 $S2 ${CODE1_CODE2}




