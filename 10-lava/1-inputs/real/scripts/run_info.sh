#!/bin/bash
#SBATCH --partition=haswell
#SBATCH --job-name=info
#SBATCH --output=./real/outputs/out.out
#SBATCH --error=./real/outputs/err.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=8GB


SUMSTATS=$1  #"../../02-ldsc/1a-munge/real/inputs/formatted-sumstats.list"

META=$2  # <- args[2]      # "../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt")



# Load modules
#module load gcc/8.1.0
#module load pcre2/10.35
#module load R/4.0.3 

module load R/3.6.0-foss-2018b


Rscript ./real/scripts/joined_to_info.R ${SUMSTATS} ${META}







