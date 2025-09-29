#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J down-other
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


wget -O ./real/outputs/${CODE} ${FILE}


# then manually inspect and modify extension/convert

# a8m and a8f manually downloaded from web, then
# version including UKBB
mv  ./real/outputs/Mahajan.NatGenet2018b.T2D.MALE.European.txt ./real/outputs/a8m.txt
mv  ./real/outputs/Mahajan.NatGenet2018b.T2D.FEMALE.European.txt ./real/outputs/a8f.txt

# NO mv ./real/outputs/Mahajan.NatGenet2018b.T2D-noUKBB.MALE.European.txt ./real/outputs/a8m.txt
# NO mv ./real/outputs/Mahajan.NatGenet2018b.T2D-noUKBB.FEMALE.European.txt ./real/outputs/a8f.txt

# a7m and a7f download manually from gdrive link, downloads a folder, from there select the desired ones from sets below (I chose her the bigger one, including UKBB and proxy (parent case))
FEMALE_PD_filtered_sumstats_no_multi_allelics_RSID.txt.gz
MALE_PD_filtered_sumstats_no_multi_allelics_RSID.txt.gz
mv FEMALE_PD_filtered_sumstats_no_multi_allelics_RSID.txt.gz a7f.gz
mv MALE_PD_filtered_sumstats_no_multi_allelics_RSID.txt.gz a7m.gz


# gzip ./real/outputs/a8f.txt
# gzip ./real/outputs/a8m.txt
# mv ./real/outputs/a8f.txt.gz ./real/outputs/a8f.gz
# mv ./real/outputs/a8m.txt.gz ./real/outputs/a8m.gz

# mv ./real/outputs/a9f ./real/outputs/a9f.gz
# mv ./real/outputs/a9m ./real/outputs/a9m.gz


# 10, 11, 12 check they have boyj sexes in one file>

# mv ./real/outputs/a10f ./real/outputs/a10f.gz
# mv ./real/outputs/a10m ./real/outputs/a10m.gz


# mv ./real/outputs/a11f ./real/outputs/a11f.gz
# mv ./real/outputs/a11m ./real/outputs/a11m.gz

# mv ./real/outputs/a12f ./real/outputs/a12f.gz
# mv ./real/outputs/a12m ./real/outputs/a12m.gz





#wait
#gzip ./real/outputs/${CODE}.txt ./real/outputs/${CODE}.gz



