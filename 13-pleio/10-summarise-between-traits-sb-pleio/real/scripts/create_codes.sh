#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J create
#SBATCH --mem 120G # memory pool for all cores
#SBATCH -t 1-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
#module load Python/3.7.4-GCCcore-8.3.0
#module load Python/3.6.6-foss-2018b
module load R/4.1.2-foss-2021b





PATHS=$(ls -d ../5-clump/real/outputs/*/)
for p in ${PATHS}
do
echo $p
basename $p >> ./real/inputs/codes.txt
done
