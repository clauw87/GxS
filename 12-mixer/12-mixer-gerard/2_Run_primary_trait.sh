#!/bin/bash
#SBATCH --job-name=mixer
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=5G
#SBATCH --array=1-20
#SBATCH --partition=haswell

module load mixer/1.3.0-Singularity-3.8.7-GCCcore-11.2.0
export SINGULARITY_BIND=$SINGULARITY_BIND,/gpfs42/robbyfs/homes/aplic/noarch/software/mixer/1.3.0-Singularity-3.8.7-GCCcore-11.2.0/mixer/reference:/REF
export MIXER_COMMON_ARGS="--ld-file /REF/ldsc/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld --bim-file /REF/ldsc/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim --threads 16"
export REP="rep${SLURM_ARRAY_TASK_ID}"
export EXTRACT="--extract /REF/ldsc/1000G_EUR_Phase3_plink/1000G.EUR.QC.prune_maf0p05_rand2M_r2p8.$REP.snps"

# Define the bind mount source and destination
bind_source="/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/12-mixer-gerard/"
bind_destination="/data"
# Define the output directory within the container
output_directory="$bind_destination/outputs_mixer/a9f"
export PYTHON="singularity exec --bind "$bind_source:$bind_destination" "$SIF/mixer.sif" python"

#Define variables
pwd="/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/12-mixer-gerard"
tempFolder="$pwd/good"
output="$pwd/outputs_mixer/a9f"
name1="a9f"
gwas1="a9f.gz"

mkdir -p $output


# Run the singularity for the first trait (ASD)
$PYTHON /tools/mixer/precimed/mixer.py fit1 \
  $MIXER_COMMON_ARGS \
  $EXTRACT \
  --trait1-file "$bind_destination/good/$gwas1" \
  --out "$output_directory/$name1.fit.$REP"

$PYTHON /tools/mixer/precimed/mixer.py test1 \
  $MIXER_COMMON_ARGS \
  --trait1-file "$bind_destination/good/$gwas1" \
  --load-params $output_directory/$name1.fit.$REP.json \
  --out $output_directory/$name1.test.$REP
