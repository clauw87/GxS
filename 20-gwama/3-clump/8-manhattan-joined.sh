JOINFILE=real/outputs/joined.clump
SNPSFILE=real/outputs/joined/result.clump.snps.csv
METAFILE=../../00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains.txt
ACCROSMAT=real/outputs/across.mat 



COMMAND="real/scripts/manhattan-joined.sh ${METAFILE} ${ACROSSMAT} ${SNPSFILE}"


sbatch ${COMMAND}


