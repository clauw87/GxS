#!bin/bash

wget https://ftp.ensembl.org/pub/release-74/variation/gvf/homo_sapiens/Homo_sapiens.gvf.gz

zcat Homo_sapiens.gvf.gz | grep ancestral_allele | grep :rs | grep dbSNP_138 | cut -f9 > ancestral_state_ensembl_release74.tsv

gzip ancestral_state_ensembl_release74.tsv

