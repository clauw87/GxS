#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J selection
#SBATCH --mem 30G # memory pool for all cores
#SBATCH -t 0-05:00 # time (D-HH:MM)
#SBATCH -o ./log/log.%j.out # STDOUT
#SBATCH -e ./log/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load Python/3.6.6-foss-2018b


PLEIOTROPIES_FILE=$2
TEST_FILE=$3
SELECTION_TEST=$4
ANCESTRAL_FILE=$5
TARGET_TRAIT=$6
ZSCORE_COLNAME=$7
OUT=$8


#--Command
python ./scripts/iHS_supplementary.py ${PLEIOTROPIES_FILE} \
                                      ${TEST_FILE} \
                                      ${SELECTION_TEST} \
                                      ${ANCESTRAL_FILE} \
                                      ${TARGET_TRAIT} \
                                      ${ZSCORE_COLNAME} \
                                      ${OUT}
