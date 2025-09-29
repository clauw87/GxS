# Tabulate number of pleios, total_common, total_fs, total_ms, positive_common, positive_fs, positive_ms and negative_common, negative_fs, negative_ms, found with PLEIO

# pair total_f, total_m, total_common, total_fs, total_ms, positive_common, positive_fs, positive_ms and negative_common, negative_fs, negative_ms

# ej a9_r9


#codes=($(cat ./real/inputs/intertrait_codes_test.txt))  

#codes=($(cat ./real/inputs/intertrait_codes_.txt))

codes=($(cat ./real/inputs/intertrait.txt))

echo code total_f total_m  pos_f pos_m total_fs total_ms pos_fs pos_ms total_common pos_common  total_con_common total_dis_common pos_con_common pos_dis_common > ./real/outputs/pleio_bet_summary.txt


for code in ${codes[@]}

do

pair=$code
#pair=r5_a9

path=../7-pleio-m-f-compare/real/outputs/$pair


#
total_f=$(cat $path/pleiof_loci.txt | grep -v LEAD_SNP | wc -l)
total_m=$(cat $path/pleiom_loci.txt | grep -v LEAD_SNP | wc -l)
#total_common=$(cat $path/pleiof_loci.txt | grep -v LEAD_SNP | grep TRUE | wc -l)
total_common=$(cat $path/pleioc_loci.txt | grep -v LEAD_SNP | wc -l)
total_fs=$(cat $path/pleiof_loci.txt | grep -v LEAD_SNP | grep FALSE | wc -l) 
total_ms=$(cat $path/pleiom_loci.txt | grep -v LEAD_SNP | grep FALSE | wc -l)


pos_f=$(cat $path/pleiof_loci.txt | grep POSITIVE | wc -l)
pos_m=$(cat $path/pleiom_loci.txt | grep POSITIVE | wc -l)

neg_f=$(cat $path/pleiof_loci.txt | grep NEGATIVE | wc -l)
neg_m=$(cat $path/pleiom_loci.txt | grep NEGATIVE | wc -l)



pos_fs=$(cat $path/pleiof_loci.txt | grep -v LEAD_SNP | grep FALSE | grep POSITIVE  | wc -l)  
pos_ms=$(cat $path/pleiom_loci.txt | grep -v LEAD_SNP | grep FALSE | grep POSITIVE  | wc -l)


neg_fs=$(cat $path/pleiof_loci.txt | grep -v LEAD_SNP | grep FALSE | grep NEGATIVE  | wc -l)  
neg_ms=$(cat $path/pleiom_loci.txt | grep -v LEAD_SNP | grep FALSE | grep NEGATIVE  | wc -l)


pos_common=$(cat $path/pleioc_loci.txt | grep POSITIVE | wc -l)
neg_common=$(cat $path/pleioc_loci.txt | grep NEGATIVE | wc -l)


total_con_common=$(cat $path/pleioc_loci.txt | grep CONCORDANT | wc -l)
total_dis_common=$(cat $path/pleioc_loci.txt | grep DISCORDANT | wc -l)


# crate a file with the SNPs and their pair to further edit in R 
if [[ $(cat $path/pleioc_loci.txt | grep DISCORDANT | wc -l) -gt 0 ]]
then
echo -e $pair '\t' $(cat $path/pleioc_loci.txt | grep DISCORDANT) >> snps_discordant.txt
fi

pos_con_common=$(cat $path/pleioc_loci.txt | grep CONCORDANT | grep POSITIVE  | wc -l)
pos_dis_common=$(cat $path/pleioc_loci.txt | grep DISCORDANT | grep POSITIVE  | wc -l)


neg_con_common=$(cat $path/pleioc_loci.txt | grep CONCORDANT | grep NEGATIVE  | wc -l)
neg_dis_common=$(cat $path/pleioc_loci.txt | grep DISCORDANT | grep NEGATIVE  | wc -l)


echo $code $total_f $total_m  $pos_f $pos_m $total_fs $total_ms $pos_fs $pos_ms $total_common $pos_common  $total_con_common $total_dis_common $pos_con_common $pos_dis_common >> ./real/outputs/pleio_bet_summary.txt


done
