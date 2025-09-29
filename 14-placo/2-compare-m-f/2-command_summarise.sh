#rm -rf ./real/outputs/shared.txt
#rm -rf ./real/outputs/shared_differential.txt
#rm -rf ./real/outputs/shared_diff_discordant.txt 
#rm -rf ./real/outputs/shared_diff_concordant.txt
#rm -rf ./real/outputs/shared_discordant.txt
#rm -rf ./real/outputs/shared_concordant.txt


#yes | rm ./real/outputs/shared_gw.txt

 
#sbatch ./real/scripts/summarise_shared.sh
#sbatch ./real/scripts/summarise_sig.sh


sbatch ./real/scripts/shared_gw.sh
sbatch ./real/scripts/shared_fdr.sh

# pleio type prevalence % per trait (traits with the most discordance with the rest)
# with R 
# sid sex uniqValue f_m pair

cat ../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | cut -f1,8,13,15 >  ./real/inputs/m_f_pairs.df


# pilot 41 traits
#cat ../../03-power-calc/real/outputs/metadata_power.txt | cut -f1,14,36  > ./real/inputs/41_traits.df


POWERED=../../02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt

cat $POWERED | grep -v "em_" | grep -v "ef_" > ./real/inputs/target.txt

METADATA=../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt


cat ${METADATA}  | cut -f1,8,13,14,15 | head -n1  > ./real/inputs/traits.txt

cat ${METADATA} | grep -f ./real/inputs/target.txt | cut -f1,8,13,14,15  >> ./real/inputs/traits.txt


Rscript ./real/scripts/trait_pleiotype.R

