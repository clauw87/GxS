#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J sample-overlap
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address



module load R


# Call sample_overlap.R with a list of rg results having all combinations of traits 
# to work with, plus the self rg results of all traits.


RG_RES=$1
OUTPUT_DIR=$2


Rscript ./real/scripts/sample_overlap.R ${RG_RES} ${OUTPUT_DIR}
