#!/bin/bash
#
#SBATCH --partition=normal
#SBATCH -N 1 # number of nodes
#SBATCH -J join
#SBATCH --mem 8G
#SBATCH -t 0-00:19 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address



cat real/outputs/*.dfline | head -n1  > ./real/outputs/results.table


cat real/outputs/*.dfline | grep -v -w pair >> ./real/outputs/results.table
