
# traits with loci
ls real/outputs/*/*result.clump.loci.csv | cut -d '/' -f3 | grep -v -w joined > ./real/tmp/traits.list
 

TRAITS=./real/tmp/traits.list
RESFILE=real/outputs/joined/result.clump.loci.csv
CLUMPED=real/outputs/joined/result.clump.snps.csv
META=../../00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains.txt

COMMAND="./real/scripts/acrossmat.sh ${TRAITS} ${RESFILE} ${CLUMPED} ${META}"

sbatch ${COMMAND}


