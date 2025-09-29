#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J gene-analysis
#SBATCH --mem 20G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


module load zlib/1.2.11-GCCcore-11.2.0

POP=$1
CODE=$2
OUTPUT_DIR=$3

MAGMA_FOLDER=/gpfs42/projects/lab_anavarro/disease_pleiotropies/tmp_claudia/magma
BFILE=${MAGMA_FOLDER}/aux_files/ref_data/${POP}/g1000
GENE_ANNOT=../../1-gene-annot/real/outputs/NCBI37.3
PVALS=../1-create-pvals-file/real/outputs
OUT=${OUTPUT_DIR}/${CODE}.gene.analysis


#COMMAND="${MAGMA_FOLDER}/magma --bfile ${BFILE} --gene-annot ${GENE_ANNOT}.genes.annot --pval ${PVALS}/${CODE}.pvals use=SNP,PVAL ncol=N --gene-model snp-wise=top --out ${OUT}"




#COMMAND="${MAGMA_FOLDER}/magma --bfile ${BFILE} --gene-annot ${GENE_ANNOT}.genes.annot --pval ${PVALS}/${CODE}.pvals use=SNP,SEXDIFFP N=30000 --gene-model snp-wise=top --out ${OUT}"

COMMAND="${MAGMA_FOLDER}/magma --bfile ${BFILE} --gene-annot ${GENE_ANNOT}.genes.annot --pval ${PVALS}/${CODE}.pvals use=SNP,SEXDIFFP ncol=NMIN --gene-model snp-wise=top --out ${OUT}"

eval $COMMAND


