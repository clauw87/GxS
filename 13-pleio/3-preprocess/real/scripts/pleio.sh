#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J pleiorun
#SBATCH --mem 200G # memory pool for all cores
#SBATCH -t 1-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
#module load Python/3.7.4-GCCcore-8.3.0
module load Python/3.6.6-foss-2018b

# Config
#INPUTS_LIST=$1
#OUTPUT_DIR=$2


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


# run pleio on thus  generated inputs
python ./real/scripts/pleio/pleio.py --metain real/outputs/metain.txt.gz --sg real/outputs/sg.txt.gz --ce real/outputs/ce.txt.gz --create --out real/outputs/pleio


# if IFS is already created IFS --ifs with a file prefix is added instead of --create
