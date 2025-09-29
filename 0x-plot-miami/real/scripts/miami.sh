#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J gwaslab-format
#SBATCH --mem 120G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


module load GWASLab/3.4.29-Miniconda3-4.9.2


INDIR=$1
ARRAY_LIST=$2
OUTDIR=$3
SUF=$4


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  CODEPAIR=$(cat ${ARRAY_LIST} | sed -n 1p)
else
  CODEPAIR=$(cat ${ARRAY_LIST} | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 



source activate gwaslab_env



python ./real/scripts/miami.py ${INDIR} ${CODEPAIR} ${SUF} ${OUTDIR}



conda deactivate
