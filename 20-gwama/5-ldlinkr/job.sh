#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J LDlinkR
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

module load R

#rm -rf real/outputs/*

#nocat ../2-analyze/real/outputs/*.sex_diff | head -n1 > ./real/inputs/alldiff
#nocat ../2-analyze/real/outputs/*.sex_diff | grep -w -f ../2-analyze/real/outputs/all.sbsnps >> ./real/inputs/alldiff
#nocat ../2-analyze/real/outputs/*.sex_diff_iii | head -n1 > ./real/inputs/alldiffiii
#nocat ../2-analyze/real/outputs/*.sex_diff_iii | grep -w -f ../2-analyze/real/outputs/all.sbsnps >> ./real/inputs/alldiffiii


Rscript real/scripts/LDlinkR.R 


