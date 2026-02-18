#!/bin/bash
#
#SBATCH -p haswell # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J env-cov
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module purge
module load modulepath/haswell
module load R/4.3.2-gfbf-2023a




# Config
INPUTS_LIST=$1
OUTPUT_DIR=$2



# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly. 
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
  INPUT_FILE=$(cat "${INPUTS_LIST}" | sed -n 1p)
else
  INPUT_FILE=$(cat "${INPUTS_LIST}" | sed -n ${SLURM_ARRAY_TASK_ID}p)
fi 


#module load R/3.6.0-foss-2018b



# Execution


rg=${INPUT_FILE}
prefix=$(basename ${INPUT_FILE} | cut -d '-' -f1)


# genetic covariance
gencov=$(cat $rg | grep gencov | cut -d ':' -f2 | cut -d ' ' -f2)
gencov_se=$(cat $rg | grep gencov | cut -d ':' -f2 | cut -d ' ' -f3 | cut -d '(' -f2 | cut -d')' -f1)


# genetic covariance intercept
sumline=$(cat $rg | grep -n Summary | cut -d ':' -f1) 
skip=$(expr $sumline + 1)
tail -n +$skip  $rg | head -n2 > ./real/tmp/${prefix}.rg_result

 # -- creates a temp file res.table
FORMATTED_RES=./real/tmp/${prefix}.rg_result
Rscript ./real/scripts/format.R ${FORMATTED_RES} 

 # -- saves the interesting variables
gcov_int=$(cat ${FORMATTED_RES} | cut -f11 | tail -n1)
gcov_int_se=$(cat ${FORMATTED_RES} | cut -f12 | tail -n1)
trait1=$(cat ${FORMATTED_RES} | cut -f13 | tail -n1)
trait2=$(cat ${FORMATTED_RES} | cut -f14 | tail -n1)


echo trait1 trait2 gencov gencov_se gcov_int gcov_int_se > ./real/tmp/${trait1}_${trait2}.in.txt
echo $trait1 $trait2 $gencov ${gencov_se} $gcov_int ${gcov_int_se} >> ./real/tmp/${trait1}_${trait2}.in.txt




# job 2 after all ok
#./real/scripts/rg_res_join.sh



# job 3 after job2 ok
#Rscript ./real/scripts/sample_overlap.R


# then in R do the rest , but when al together instead of one by one
# in R gcov_int - gencov > envcov
# for one per one: Rscript ./real/scripts/subst.R ./real/tmp/${trait1}_${trait2}.in.txt ./real/outputs/${trait1}_${trait2}.txt  
#Rscript ./real/scripts/subst.R ./real/tmp/rg_res
