#!/bin/bash
#SBATCH --job-name=combi_placo
#SBATCH --output=./real/outputs/out.out
#SBATCH --error=./real/outputs/err.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=64GB

# mail alert at start, end and abortion of execution
#SBATCH --mail-type=END
#SBATCH --mail-user=claudia.vasallo@upf.edu





inputfileslist=$1
outfile=$2


# Get combinations of pairs of traits to analyse


phenos=(`cat ${inputfileslist} | cut -f 1 `) 
awk -f ./real/scripts/combinations.awk <<< ${phenos[@]} > ${outfile}
 

