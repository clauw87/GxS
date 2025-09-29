#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J match
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-20:00 # time (D-HH:MM)
#SBATCH -o ./real/inputs/log.%j.out # STDOUT
#SBATCH -e ./real/inputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


Rscript real/scripts/matchfile.R

