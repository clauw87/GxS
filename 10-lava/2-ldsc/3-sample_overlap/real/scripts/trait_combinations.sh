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



inputfile=$1
outputfile=$2


# Get combinations of pairs of traits to analyse
phenos=(`cat ${inputfile} | cut -f1 `) 


awk -f ./real/scripts/combinations.awk <<< ${phenos[@]} > ${outputfile}
 
