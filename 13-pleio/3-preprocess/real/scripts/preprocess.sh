#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J pleio-preprocess
#SBATCH --mem 120G # memory pool for all cores # with 60 G just 4 jobs failed bc of memory
#SBATCH -t 9-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load R
module load Miniconda3/4.9.2
source activate ldsc_pleio

# Config
# combi list file or similar with combination space separated in each line
INPUTS_LIST=$1
OUTPUT_DIR=$2


# Input combination
# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  INPUT=$(cat "${INPUTS_LIST}" | sed -n 1p)
else
  INPUT=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 


echo $INPUT

   
  # Configuration - for pairwise two automatically generated space separated ids are created with combinations.awk, for custom groups, manually space separated ids need to be created  
  RUN_NAME=$(echo $(echo $INPUT  | cut -d ' ' -f1)'_'$(echo $INPUT | cut -d ' ' -f2))
  RUN_IDS=./real/inputs/${RUN_NAME}
 
  for w in $(seq 1 $(echo ${INPUT} | wc -w))
  do
    echo $INPUT | cut -d ' ' -f${w} >> ${RUN_IDS}
  done

  mkdir ./real/outputs/${RUN_NAME}


  # Inputs
  METADATA=../../3-power-calc/real/inputs/metadata.txt 
  # Make inputs sumstats list file by grepping desired sids or a long sid list from file in the pleio munge outputs 
  ls -d ../2-munge/real/outputs/* | grep gz | grep -f ${RUN_IDS}  > ./real/inputs/formatted.list.${RUN_NAME}
  

  SUMSTATS_LIST=./real/inputs/formatted.list.${RUN_NAME}
  SUFFIX='.gz'


#module load R

  Rscript ./real/scripts/create_input_list.R $METADATA $SUMSTATS_LIST $SUFFIX $RUN_NAME

   
  INPUT_LIST=real/inputs/input_list_${RUN_NAME}.txt
  OUTPUT_DIR=./real/outputs/${RUN_NAME}



#module load Miniconda3/4.9.2
#source activate ldsc_pleio


python ./real/scripts/pleio/ldsc_preprocess.py \
	--input ${INPUT_LIST} \
	--ref-ld-chr ../../../Software/ldsc/eur_w_ld_chr/ \
	--w-ld-chr ../../../Software/ldsc/eur_w_ld_chr/ \
	--out ${OUTPUT_DIR}

conda deactivate
