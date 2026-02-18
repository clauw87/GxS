#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH --job-name=rg_diff1
#SBATCH --output=./real/outputs/out.out
#SBATCH --error=./real/outputs/err.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=200GB
#SBATCH --mail-type=END
#SBATCH --mail-user=claudia.vasallo@upf.edu


module purge
module load modulepath/haswell
module load R/4.3.2-gfbf-2023a
module load Python/3.11.3-GCCcore-12.3.0

# CONFIG
RES=$1
METAF=$2
MINUS=$3
OUTPUT_DIR=$4


# calc diff
Rscript ./real/scripts/intratrait_diff.R  ${RES} ${METAF} ${MINUS}


# plot

SIG_LEVEL=fdr
Rscript ./real/scripts/rg-diff1-barplot.R
python ./real/scripts/rg-diff1-barplot_uni.py ${OUTPUT_DIR} ${MINUS} ${METAF} ${SIG_LEVEL}


SIG_LEVEL=nominal
Rscript ./real/scripts/rg-diff1-barplot.R
# rg_intratrait_nominal.txt
# rg_intratrait_fdr.txt
python ./real/scripts/rg-diff1-barplot_uni.py ${OUTPUT_DIR} ${MINUS} ${METAF} ${SIG_LEVEL}


