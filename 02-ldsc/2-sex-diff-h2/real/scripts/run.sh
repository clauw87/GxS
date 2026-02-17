#!/bin/bash
#SBATCH --partition=haswell
#SBATCH --job-name=h2_diff
#SBATCH --output=./real/outputs/out.out
#SBATCH --error=./real/outputs/err.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16GB
# mail alert at start, end and abortion of execution
#SBATCH --mail-type=END
#SBATCH --mail-user=claudia.vasallo@upf.edu



POWERED_FILE=$1
METADATA=$2
OUTPUTS_DIR=$3 # ./real/outputs

#rm -rf ./real/outputs/*



module purge
module load modulepath/haswell
module load R/4.3.2-gfbf-2023a

module load Python/3.11.3-GCCcore-12.3.0
# had to pip3 install seaborn

#module load Python/3.12.3-GCCcore-13.3.0
#module load Python/3.11.5-GCCcore-13.2.0
#module load Python/3.10.4-GCCcore-11.3.0-bare

#METADATA=../03-power-calc/real/outputs/joined_metadata_power.txt


H2_FILE=../../01d-power-calc/real/outputs/h2_liab.txt
#POWERED_FILE=../2-join_h2_results/real/outputs/h2_powered_2.txt


#cat ${POWERED_FILE} | grep -v em_ | grep -v ef_ > ./real/inputs/target.txt
cat ${POWERED_FILE}  > ./real/inputs/target.txt

TARGET=./real/inputs/target.txt

Rscript ./real/scripts/compare_h2.R ${H2_FILE} ${TARGET} ${METADATA} ${OUTPUTS_DIR} 

# in above code alreadyRscript ./real/scripts/h2_plot_table.R ./real/outputs/compare_h2_liab_scale.txt

cat ./real/outputs/compare_h2_liab_scale.txt | grep -v elena | grep -v neales > ./real/outputs/compare_h2_liab_scale.txt
Rscript ./real/scripts/h2_plot_table.R ./real/outputs/compare_h2_liab_scale.txt

# m-f bars on one line
#python ./real/scripts/h2_diff.py ./real/outputs/compare_h2_liab_scale_minuselena.txt ${OUTPUTS_DIR} 'nominal' ${METADATA}
python ./real/scripts/h2_diff.py ./real/outputs/compare_h2_liab_scale.txt ${OUTPUTS_DIR} 'nominal' ${METADATA}

python ./real/scripts/h2_diff.py ./real/outputs/compare_h2_liab_scale.txt ${OUTPUTS_DIR} 'fdr' ${METADATA}

