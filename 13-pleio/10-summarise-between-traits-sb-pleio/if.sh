


if [[ $(cat $path/pleioc_loci.txt | grep DISCORDANT | wc -l) -gt 0 ]]
then
echo $pair $(cat $path/pleioc_loci.txt | grep DISCORDANT) >> snps_discordant.txt
fi
