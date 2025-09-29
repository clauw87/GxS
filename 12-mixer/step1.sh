#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J mixer
#SBATCH --mem 200G # memory pool for all cores
#SBATCH -t 1-23:59 # time (D-HH:MM)
#SBATCH -o ./log.%j.out # STDOUT
#SBATCH -e ./log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load mixer/1.2-GCCcore-8.2.0


# Config
#INPUTS_LIST=$1
#OUTPUT_DIR=$2


MIXER_PATH=/aplic/noarch/software/mixer/1.2-GCCcore-8.2.0


# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number

#if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
#then
#  INPUT_FILE=$(cat "${INPUTS_LIST}" | sed -n 1p)
#else
#  INPUT_FILE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
#fi 






python3 $MIXER_PATH/precimed/mixer.py ld \
	--lib $MIXER_PATH/src/build/lib/libbgmg.so \
	--bfile ../../reference/1000G/EUR/1000G_Phase3_EUR_plink/1000G.EUR.QC.22 \
	--out ./real/tmp/1000G.EUR.QC.22.run4.ld \
	--r2min 0.05 --ldscore-r2min 0.05 --ld-window-kb 30000
