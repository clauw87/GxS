#zcat 1000G_phase3.tsv.gz | grep --color=auto -w 22 | grep --color=auto -w 51236013


zcat 1000G_phase3.tsv.gz | grep -w 22 | grep -w -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/real/inputs/chr22-snps-by-build/hg19_22_pos | wc -l

zcat 1000G_phase3.tsv.gz | grep -w 22 | grep -w -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/01-format/real/inputs/chr22-snps-by-build/hg38_22_pos | wc -l




