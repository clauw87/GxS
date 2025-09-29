#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J convert_to_entrez
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 0-05:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load R/4.2.0-foss-2021b

# Config
JOBLIST=$1
GENESETS_FOLDER=$2
OUTPUT_DIR=$3
GENESET=$4

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item corresponding to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  TRAIT=$(basename $(cat ${JOBLIST} | sed -n 1p | cut -d ' ' -f2) | cut -d '.' -f1)  
  FILE=$(cat ${JOBLIST} | sed -n 1p | cut -d" " -f2)
  CODE=$(basename ${FILE} | cut -d "." -f1)
  #POP=$(cat ${JOBLIST} | sed -n 1p | cut -d" " -f3)
else
  TRAIT=$(basename $(cat ${JOBLIST} | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f2) | cut -d '.' -f1)
  FILE=$(cat ${JOBLIST}  | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f2)
  CODE=$(basename ${FILE} | cut -d "." -f1)
  #POP=$(cat ${JOBLIST}  | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f3)
fi 


#GENEOUTFILE=$(ls ../2-gene-analysis_caas/2-gene-analysis/real/outputs/ | grep .genes.out | grep ${CODE})

# Create Background and results genesets per trait

Rscript ./real/scripts/ensembl_to_entrez.R ${TRAIT} ${CODE} ${GENESETS_FOLDER} ${GENESET}





