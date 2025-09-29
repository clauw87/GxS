#!/bin/bash
#
#SBATCH -p normal #haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J GWAMA
#SBATCH --mem 60G
#SBATCH -t 0-03:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR



# Modules

# Config
ARRAY_LIST=$1     # file with full path!!!!!! to pair merged files
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
  FILE1=(`cat ${ARRAY_LIST} | sed -n 1p | cut -f1`)
  FILE2=(`cat ${ARRAY_LIST} | sed -n 1p | cut -f2`)
else
  FILE1=(`cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -f1`)
  FILE2=(`cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -f2`)
fi


CODE1=$(basename ${FILE1} |  cut -d'.' -f1)
CODE2=$(basename ${FILE2} |  cut -d'.' -f1)

# needs to be unzipped
zcat ${FILE1} | tr '\t' ' ' > ./real/tmp/${CODE1}.txt
zcat ${FILE2} | tr '\t' ' ' >	./real/tmp/${CODE2}.txt


echo ./real/tmp/${CODE1}.txt M > ./real/tmp/${CODE1}.${CODE2}
echo ./real/tmp/${CODE2}.txt F >> ./real/tmp/${CODE1}.${CODE2}


./real/scripts/gwama/GWAMA \
--filelist ./real/tmp/${CODE1}.${CODE2} \
--output ${OUTPUT_DIR}/${CODE1}:${CODE2}.meta \
--sex \
--no_alleles \
--quantitative \
--name_beta BETA \
--name_se SE_BETA \
--name_n N \
--name_marker SNP \
--name_eaf FREQ \
--random


# https://genomics.ut.ee/en/tools

# p-value - Meta-analysis p-value

# gender_differentiated_p-value - combined p-value of males and females assuming different effect sizes between genders (2 degrees of freedom)

# gender_heterogeneity_p-value - heterogeneity between genders (1 degree of freedom)
