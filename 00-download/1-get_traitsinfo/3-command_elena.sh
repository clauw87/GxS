# adds elena's non-bin taking N from Neale's
# adds elena's bin from elena's table s1

module load R

cp ../5-elena/TableS1.txt real/inputs/
cp ../5-elena/selected_trait_code.txt real/inputs/elena_selected_trait_codes.txt


cat real/inputs/neales_metadata.txt | head -n1 > real/tmp/elenas_neales_metadata.txt
cat real/inputs/neales_metadata.txt |  grep -f real/inputs/the_70.fixedname | grep -f /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/0-download/1-get_traitsinfo/the_70_description | sort -u   >> real/tmp/elenas_neales_metadata.txt
#grep -v ordered 


Rscript	real/scripts/elena_meta.R

Rscript real/scripts/elena_meta_nonbin.R


Rscript real/scripts/elena_meta_bin.R


