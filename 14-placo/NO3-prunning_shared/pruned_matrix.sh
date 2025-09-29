#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J matpruned
#SBATCH --mem 32G # memory pool for all cores
#SBATCH -t 0-16:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address



# Matrix of concordant/discordant shared pleio loci per disease pairs , for heatmap


# SHARED_PRUNED results list (we had a similar table before prunning and the list of the SNPs)

RES=($(ls real/outputs_join/*.shared.pruned))

# eg
#RE=real/outputs_loop/157m_a22m_159f_a22f.shared.pruned


echo CODE TOTAL CON DIS > pruned_matrix.txt
for RE in ${RES[@]}
do
CODE=$(echo $RE | cut -d"/" -f3 | cut -d"." -f1)
TOTAL=$(cat ${RE} | grep -v SNP | wc -l)
CON=$(cat ${RE} | grep -v SNP | grep CONCORDANT | wc -l)
DIS=$(cat ${RE} | grep -v SNP | grep DISCORDANT | wc -l)
echo $CODE $TOTAL $CON $DIS >> pruned_matrix.txt
done
