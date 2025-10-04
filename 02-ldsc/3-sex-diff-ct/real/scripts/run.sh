#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J ct-diff-tab-heatmap
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module purge
module load modulepath/haswell
module load R/4.3.2-gfbf-2023a

# Config
RESULT=$1
POWER=$2
META=$3


Rscript ./real/scripts/crosstrait_diff.R  ${RESULT} ${POWER} ${META}

SIG_LEVEL="nominal" 
Rscript ./real/scripts/heatmaps.ct.R ${SIG_LEVEL}

SIG_LEVEL="fdr" 
Rscript ./real/scripts/heatmaps.ct.R ${SIG_LEVEL}




