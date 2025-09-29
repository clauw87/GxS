#!/bin/bash
#
#SBATCH --partition=haswell
#SBATCH --job-name=lava
#SBATCH --output=./real/outputs/messages.log.%j.out
#SBATCH --error=./real/outputs/messages.log.%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=64GB

module load R/3.6.0-foss-2018b




# Config
PHENOS=$1
INFOFILE=$2        # ../input/input.info.txt
SAMPLEOVERLAP=$3   # ../sample_overlap/sample.overlap.txt
SEX=$4
REFERENCE=$5       # ../input/g1000_eur/g1000_eur
LOCFILE=$6         # ../input/blocks_s2500_m25_f1_w200.locfile
OUTPUTS=$7
UNIVTHR=$8


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then  
  CODE1=$(cat "${PHENOS}" | sed -n 1p | cut -d ' ' -f1)
  CODE2=$(cat "${PHENOS}" | sed -n 1p | cut -d ' ' -f2)
else
  CODE1=$(cat "${PHENOS}" | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f1)
  CODE2=$(cat "${PHENOS}" | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d ' ' -f2)
fi 



Rscript ./real/scripts/run_lava.R ${SEX} ${REFERENCE} ${LOCFILE} ${INFOFILE} ${SAMPLEOVERLAP} "${CODE1}:${CODE2}" ${OUTPUTS} ${UNIVTHR}

