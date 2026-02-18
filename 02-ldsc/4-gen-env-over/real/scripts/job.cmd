#!/bin/bash
#SBATCH --job-name=so
#SBATCH --output=./out.out
#SBATCH --error=./err.err
#SBATCH --nodes=1
#SBATCH --ntasks=1



#load modules
#module load gcc/8.1.0
#module load pcre2/10.35
#module load R/4.0.3 

module load R/3.6.0-foss-2018b

./rg_res_join.sh

Rscript sample_overlap.R







