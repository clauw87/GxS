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



Rscript ./real/scripts/intratrait_diff.R  ${RES}

Rscript ./real/scripts/rg-diff1-barplot.R


# CONFIG
RES=$1

