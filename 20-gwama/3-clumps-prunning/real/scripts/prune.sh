#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J prune-sb
#SBATCH --mem 120G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

module load R




POOLED=$1 # ../2-analyze/real/outputs/pooled.sbsnps
CODE=$2 # "all"
TYPE=$3  # "sbsnp"
OUTPUTS=$4   # ./real/outputs



# 
Rscript ./real/scripts/SNPclip_sbsnps.R ${POOLED} ${CODE} ${TYPE} ${OUTPUTS}
