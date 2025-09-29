module load zlib/1.2.11-GCCcore-11.2.0


MAGMA_FOLDER=../../../../disease_pleiotropies/tmp_claudia/magma

SNP_LOC=${MAGMA_FOLDER}/aux_files/ref_data/EUR/g1000.bim



GENE_LOC=${MAGMA_FOLDER}/aux_files/gene_loc_build37/NCBI37.3.gene.loc

OUT=./real/outputs/NCBI37.3

COMMAND="${MAGMA_FOLDER}/magma --annotate window=5,5 --snp-loc ${SNP_LOC} --gene-loc ${GENE_LOC} --out ${OUT}"

eval $COMMAND




# PVAL FILE

#zcat ../
