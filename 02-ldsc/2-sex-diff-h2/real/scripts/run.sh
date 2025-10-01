#!/bin/bash
#SBATCH --partition=haswell
#SBATCH --job-name=h2_res_join
#SBATCH --output=./real/outputs/out.out
#SBATCH --error=./real/outputs/err.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16GB
# mail alert at start, end and abortion of execution
#SBATCH --mail-type=END
#SBATCH --mail-user=claudia.vasallo@upf.edu


module purge
module load modulepath/haswell
module load R/4.3.2-gfbf-2023a


# Config
POWERED_FILE=$1
METADATA=$2
OUTPUT_DIR=$3 

H2_FILE=../../01d-power-calc/real/outputs/h2_liab.txt
cat ${POWERED_FILE}  > ./real/inputs/target.txt
TARGET=./real/inputs/target.txt

Rscript ./real/scripts/compare_h2.R ${H2_FILE} ${TARGET} ${OUTPUTS_DIR}

Rscript ./real/scripts/h2_plot_table.R ./real/outputs/compare_h2_liab_scale.txt ${OUTPUTS_DIR}
