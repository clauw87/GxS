

#cat real/inputs/res.list_iii | xargs -I {} basename {} | cut -d '.' -f1 > ./real/tmp/traits.list

# traits with loci
ls real/outputs/*/result.clump.loci.csv | cut -d '/' -f3 | grep -v -w joined > ./real/tmp/traits.list
 

#ls real/outputs/*/result.clump.lead.csv | cut -d '/' -f3 > ./real/tmp/traits.list


TRAITS=./real/tmp/traits.list
RESFILE=real/outputs/joined/result.clump.loci.csv
CLUMPED=real/outputs/joined/result.clump.snps.csv

COMMAND="./real/scripts/acrossmat.sh ${TRAITS} ${RESFILE} ${CLUMPED}"

sbatch ${COMMAND}


