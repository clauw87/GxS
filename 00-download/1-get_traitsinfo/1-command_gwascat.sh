#!/bin/bash
#SBATCH --job-name=traitsinfo.job
#SBATCH --output=traitsinfo.out
#SBATCH --error=traitsinfo.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16GB





module load Python/3.6.6-foss-2018b




python ./real/scripts/gwasatlas_translator.py  
