#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J env-cov2
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


# job 2 after all ok
./real/scripts/rg_res_join.sh



# job 3 after job2 ok
module purge
module load modulepath/haswell
module load R/4.3.2-gfbf-2023a



Rscript ./real/scripts/sample_overlap.R


