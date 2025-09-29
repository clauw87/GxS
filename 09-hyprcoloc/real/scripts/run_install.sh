#!/bin/bash
#SBATCH -p haswell
#SBATCH --job-name=install
#SBATCH --output=out.out
#SBATCH --error=err.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=64GB



module load R/4.2.0-foss-2021b


Rscript install_hyperloc.R
