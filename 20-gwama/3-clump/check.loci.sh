#outfolder=./real/ouputs
# real/outputs/joined-loci.list

LOCILIST=real/outputs/joined-loci.list


# total traits with sex-biased loci
cat ${LOCILIST} | cut -d ',' -f2 | grep -v TOTAL | grep -v -w 0 | wc -l

# traits with different but same direction
cat ${LOCILIST} | cut -d ',' -f3 | grep -v POS | grep -v -w 0 | wc -l

# traits with different by opposite direction
cat ${LOCILIST} | cut -d ',' -f4 | grep -v NEG | grep -v -w 0 | wc -l




 cat *.sbloci | cut -d ',' -f4 | grep -v SNP | sort -u > all.lead.sbsnps
