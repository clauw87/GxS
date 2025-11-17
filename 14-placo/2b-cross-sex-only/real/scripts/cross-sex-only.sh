#!/bin/bash
#
#SBATCH -p haswell # haswell (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J crossplaco
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 9-23:59 # time (D-HH:MM)
#SBATCH -o ./real/outputs/messages.log.%j.out # STDOUT
#SBATCH -e ./real/outputs/messages.log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

# Modules
module purge
module load modulepath/haswell
module load R/4.3.2-gfbf-2023a

META=/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains_updated.txt

TARGET=/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt

cat $META | head -n1 > ./real/inputs/target_meta.txt
cat $META | grep -w -f $TARGET >> ./real/inputs/target_meta.txt


TARGETMETA=./real/inputs/target_meta.txt

INPUTS_DIR=../1-run-placo/real/outputs/
OUTPUTS_DIR=./real/outputs

CROSS=/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/1-run-placo/real/tmp/crosscross
CT=/gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/14-placo/1-run-placo/real/tmp/combipairs

Rscript ./real/scripts/mer.R ${TARGETMETA} ${CROSS} ${CT} ${INPUTS_DIR}  ${OUTPUTS_DIR}
