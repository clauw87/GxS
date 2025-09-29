#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J down-zip
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module load Python/3.6.6-foss-2018b



# Config
#SOMETHING=$1

# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item corresponding to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  CODE=$(cat ./real/inputs/jobsList.txt | sed -n 1p | cut -d" " -f1)
  FILE=$(cat ./real/inputs/jobsList.txt | sed -n 1p | cut -d" " -f2)
else
  CODE=$(cat ./real/inputs/jobsList.txt | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f1)
  FILE=$(cat ./real/inputs/jobsList.txt | sed -n ${SLURM_ARRAY_TASK_ID}p | cut -d" " -f2)
fi


#python ./test/scripts/atlas_download_100.py
#python ./test/scripts/atlas_download_easyones.py
#python ./real/scripts/atlas_download.py ${CODE} ${FILE}  


wget -O ./real/outputs/${CODE}.zip ${FILE}



# a5f
unzip real/outputs/a5f.zip -d ./real/outputs/a5f
mv real/outputs/a5f/chen_and_cade_et_al_2018_ahi_3_percent_combined_females.txt real/outputs/a5f/a5f
gzip real/outputs/a5f/a5f real/outputs/a5f/a5f.gz

# a5m
unzip real/outputs/a5m.zip -d ./real/outputs/a5m
mv real/outputs/a5m/chen_and_cade_et_al_2018_ahi_3_percent_combined_males.txt real/outputs/a5m/a5m   
gzip real/outputs/a5m/a5m real/outputs/a5m/a5m.gz



# a13m
unzip real/outputs/a13m.zip -d ./real/outputs/a13m
mv real/outputs/a13m/GWAMA.CAD.INTERMEDIATE.SENSITIVITY.UKBB.PLUS.EXTRA.STUDIES.QCed.txt.gz ./real/outputs/a13m/a13m.gz
# a13f
unzip real/outputs/a13f.zip -d ./real/outputs/a13f
mv real/outputs/a13f/GWAMA.CAD.INTERMEDIATE.SENSITIVITY.UKBB.PLUS.EXTRA.STUDIES.QCed.txt.gz ./real/outputs/a13f.gz



# a26
unzip real/outputs/a26m.zip -d ./real/outputs/a26m
mkdir real/outputs/a26f
mv real/outputs/a26m/cade_et_al_2021_ahi_3_percent_european_ancestry_females.txt.gz  real/outputs/a26f/a26f.gz
mv real/outputs/a26m/cade_et_al_2021_ahi_3_percent_european_ancestry_males.txt.gz  real/outputs/a26m/a26m.gz



