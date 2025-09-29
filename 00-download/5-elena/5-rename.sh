#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J format_sumstats
#SBATCH --mem 80G # memory pool for all cores
#SBATCH -t 0-05:00 # time (D-HH:MM)
#SBATCH -o log.%j.out # STDOUT
#SBATCH -e log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address



#find $(readlink -f ./) -iname '*.gz'  | grep -v regenie   > sumstats_list_e


FILES=$(cat sumstats_list_e)
#DIRNAMES=$(cat sumstats_list_e | xargs -I {} dirname {} )
#BASENAMES=$(cat sumstats_list_e | xargs -I {} basename {} )

for FILE in ${FILES[@]}
do
#DIRNAME=$( dirname ${FILE} )
#NEWBASENAME=$( basename ${FILE} | sed 's/beta.sexcomparison_//')
#echo ${DIRNAME}/ef_${NEWBASENAME}
#cp ${FILE} ${DIRNAME}/ef_${NEWBASENAME}
#cp ${FILE} ${DIRNAME}/em_${NEWBASENAME}
yes | rm -rf ${FILE}
done



