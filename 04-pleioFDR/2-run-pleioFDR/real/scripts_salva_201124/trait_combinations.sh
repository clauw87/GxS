#!/bin/bash
#SBATCH --job-name=pleiofdr
#SBATCH --output=./real/outputs/out.out
#SBATCH --error=./real/outputs/err.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=64GB

# mail alert at start, end and abortion of execution
#SBATCH --mail-type=END
#SBATCH --mail-user=claudia.vasallo@upf.edu



#load modules
module load Python/2.7.15-foss-2018b
#module load PLINK/1.9b
#module load MATLAB/2016a 


inputfileslist=$1
inputsfolder=./real/inputs

# Get combinations of pairs of traits to analyse

phenos=(`cat ${inputfileslist} | cut -f 1 `) 


awk -f ./real/scripts/combinations.awk <<< ${phenos[@]} > ./${inputsfolder}/phenoscomb
 
