#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J manplot
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


JOINED_FILE=$1
COORDS_FILE=$2
METADATA_FILE=$3


#python ./real/scripts/manhattan-joined.py ${JOINED_FILE}

python ./real/scripts/manhattan-stacked.py ${JOINED_FILE} ${COORDS_FILE} ${METADATA_FILE}
