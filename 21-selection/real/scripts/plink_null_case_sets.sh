# Inputs
# allcases.indep.test.df3.tsv and allcases.test.df3.tsv obtained with format_ref3.R using using allchrs.${case}.ld_exclude_0.6.txt (LD exclusion list within 500K window) 
# (case status column is case plus ld0.6-500k, case status no ld is signal-only (no LD-linked) case SNPs while case_indep are signal_only indep case SNPs, null sets are suffixed as null and null.indepsnps) 
# These two will be used for Kmeans.
# These two and the case indep version of allcases.test.df3.tsv (allcases.indep.test.df3.tsv) is used for matching_test3.R

# - 1000GQC PLINK set used as control for summstats formatting: ~/Documents/gxs_results/selection/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chr}

# - Lists of case SNPs:
# -- case 0: sex-biased SNPs: /home/cvasallo/Documents/gxs_results/selection/sb_selection_formatted_summary
# cat /home/cvasallo/Documents/gxs_results/selection/sb_selection_formatted_summary | awk ' $1!="SNP" {print $1}' | sort -u > /home/cvasallo/Documents/gxs_results/selection/case0.ids
# -- case 1: repeated multidomains sex-biased SNPs:
# /home/cvasallo/Documents/gxs_results/selection/sb_selection_formatted_summary
# cat /home/cvasallo/Documents/gxs_results/selection/sb_selection_formatted_summary  | awk ' $5>1 {print $1}' | grep -v -w SNP > /home/cvasallo/Documents/gxs_results/selection/case1.ids
# --case 2: cross-domain sex-specific (pPLACO other is greater than 0.05) pleioropic SNPs.
# /home/cvasallo/Documents/gxs_results/selection/pleio_selection_formatted_summary
# cat /home/cvasallo/Documents/gxs_results/selection/pleio_selection_formatted_summary  |  awk ' $3=="TRUE" {print $1}' > /home/cvasallo/Documents/gxs_results/selection/case2.ids
# --case 3: cross-domain pleiotropic SNPs that are sex-biased or LD linked with them
# cat /home/cvasallo/Documents/gxs_results/selection/pleio_selection_formatted_summary  |  awk ' $2>1 {print $1}' | grep -w -f /home/cvasallo/Documents/gxs_results/selection/case0.ids > /home/cvasallo/Documents/gxs_results/selection/case3.ids
# cat /home/cvasallo/Documents/gxs_results/selection/pleio_selection_formatted_summary  |  awk ' $2>1 {print $1}' | grep -F -w /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_exclude.txt
# Instead, get the intersect of both LD proxies lists>
# case3a 
# cat /home/cvasallo/Documents/gxs_results/selection/pleio_selection_formatted_summary  |  awk ' $2>1 {print $1}' > /home/cvasallo/Documents/gxs_results/selection/case3a.ids
# case3b > then intersect LD proxies with case1 LD proxies
# /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_exclude.txt
# --case 4: cross-domain sex-shared but effects discordant pleiotropic SNPs
# /home/cvasallo/Documents/gxs_results/selection/pleio_selection_formatted_summary
# cat /home/cvasallo/Documents/gxs_results/selection/pleio_selection_formatted_summary | awk ' $4=="TRUE" {print $1}' > /home/cvasallo/Documents/gxs_results/selection/case4.ids
# --case 5: cross-sex-only pleiotropic SNPs. 
# Marvin2 /gpfs/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas_new/04-pleioFDR/2-run-pleioFDR (done with ws_vs_cs.sh outputs in form./tmp/$cs1.$cs2.csonly.pleiosnps)
# cat alltraits.csonly.pleiosnps.csv > /home/cvasallo/Documents/gxs_results/selection/case5.ids
# --anycase
# cat /home/cvasallo/Documents/gxs_results/selection/case0.ids /home/cvasallo/Documents/gxs_results/selection/case1.ids /home/cvasallo/Documents/gxs_results/selection/case2.ids /home/cvasallo/Documents/gxs_results/selection/case3.ids /home/cvasallo/Documents/gxs_results/selection/case4.ids /home/cvasallo/Documents/gxs_results/selection/case5.ids |  grep -v -w SNP | sort -u > /home/cvasallo/Documents/gxs_results/selection/case.ids




# Do for each case:

case_list=/home/cvasallo/Documents/gxs_results/selection/${case}.ids

case="case4"


#PLINK

# 1. Get target case group and LD partners

# Get LD table of case-nulls SNPs
case_list=/home/cvasallo/Documents/gxs_results/selection/${case}.ids
for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile ~/Documents/gxs_results/selection/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chr} \
      --ld-snp-list ${case_list} \
      --ld-window-kb 500 \
      --ld-window 99999 \
      --ld-window-r2 0.8 \
      --r2 \
      --out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_partners_0.8
done


# Extract unique LD partners (both SNP_A and SNP_B columns)

for chr in {1..22}; do
# adds targeted
awk 'NR>1 {print $3}' /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_partners_0.8.ld > /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_snps_0.8.txt
# add linked
awk 'NR>1 {print $6}' /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_partners_0.8.ld  >> /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_snps_0.8.txt
sort -u /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_snps_0.8.txt > /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_exclude_0.8.txt
done

cat /home/cvasallo/Documents/gxs_results/selection/*.${case}.ld_exclude_0.8.txt >  /home/cvasallo/Documents/gxs_results/selection/allchrs.${case}.ld_exclude_0.8.txt 

Indep dataset at 0.2 intersect with caseplusldproxy0.8
cat /home/cvasallo/Documents/gxs_results/selection/allchrs.refdataset.indepsnps2 | grep -w -f /home/cvasallo/Documents/gxs_results/selection/allchrs.${case}.ld_exclude_0.8.txt 


# For case3, here formed as intersect of case3a and case3b
for chr in {1..22}; do
cat /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_exclude.txt | grep -w -f /home/cvasallo/Documents/gxs_results/selection/chr${chr}.case0.ld_exclude.txt > 
/home/cvasallo/Documents/gxs_results/selection/chr${chr}.case3.ld_exclude.txt
done



# 2. Generate case null PLINK by excluding those SNPs

# Remove signal SNPs and their LD partners and create null plink (exclude)

for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile ~/Documents/gxs_results/selection/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chr} \
      --exclude /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_exclude_0.6.txt \
      --make-bed \
      --out  /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.signal_clean
done


# Create case and LD partners plink (extract signal snps and ld linked ones)

for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile ~/Documents/gxs_results/selection/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chr} \
      --extract /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.ld_exclude_0.6.txt \
      --make-bed \
      --out  /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}
done




# Create signal-only case plink (extract signal snps but not ld linked ones)

for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile ~/Documents/gxs_results/selection/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chr} \
      --extract /home/cvasallo/Documents/gxs_results/selection/${case}.ids \
      --make-bed \
      --out  /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.signal_only
done






# Here merge non-pruned SNPs within ref file for case ascribing and then LD prune the present in ref 

# 3. Get indep case-null set

# Merge with reference
cat match_ref_ihs_sds_fst_b2_cadd.tsv | cut -f1 | grep -v -w SNP > match_ref_ihs_sds_fst_b2_cadd.ids
REF_DATASET_SNPS=/home/cvasallo/Documents/gxs_results/selection/match_ref_ihs_sds_fst_b2_cadd.ids



for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile  /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.signal_clean \
      --extract /home/cvasallo/Documents/gxs_results/selection/match_ref_ihs_sds_fst_b2_cadd.ids \
      --make-bed \
      --out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.null.refmerged
done



# LD Prune case-null set to get case-null indep SNPs
for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
--bfile /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.null.refmerged \
--indep-pairwise 50 5 0.2 \
--out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.null.prune
done


# Extract pruned ins and create indep case-null plink set
for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.null.refmerged \
      --extract /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.null.prune.prune.in \
      --make-bed \
      --out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.null
done


# 4. Get independent case set
(same but for case PLINK set, this attemps as getting more intersections of case SNPs that were not as such in ref file but maybe an LD partner is, makes sense?)
(case plus ld partners)

for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile  /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}_2 \
      --extract ${REF_DATASET_SNPS} \
      --make-bed \
      --out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.refmerged2
done










caseonly
for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile  /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.signal_only \
      --extract  ${REF_DATASET_SNPS}\
      --make-bed \
      --out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.signal_only.refmerged2
done





# LD Prune case set to get indep case SNPs 
# case plus LD partners
for chr in {1..22}
do
~/Downloads/plink_linux_x86_64_20250615/plink \
--bfile /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.refmerged2 \
--indep-pairwise 50 5 0.2 \
--out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.prune2
done

# case only SNPs
indep-pairwise 50 5 0.5   _2

for chr in {1..22}
do
~/Downloads/plink_linux_x86_64_20250615/plink \
--bfile /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.signal_only.refmerged2 \
--indep-pairwise 50 5 0.2 \
--out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.signal_only.prune2
done



IF errors, less than 2 SNPs, add SNP itself
# case plus LD partners

for chr in {1..22}
do
err_val=$(cat /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.prune2.log | grep Err | wc -l)
if [[ err_val -gt 0 ]]
then
echo ${chr} Error
cat /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.refmerged2.bim | awk '{print $2}' > /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.prune2.prune.in
fi
done




# Extract pruned in and create indep case plink set case plus ld partners
for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.refmerged2 \
      --extract /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.prune2.prune.in \
      --make-bed \
      --out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case2
done







# case only SNPs
for chr in {1..22}
do
err_val=$(cat /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.signal_only.prune2.log | grep Err | wc -l)
if [[ err_val -gt 0 ]]
then
echo ${chr} Error
cat /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.signal_only.refmerged2.bim | awk '{print $2}' > /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.signal_only.prune2.prune.in
fi
done






for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.signal_only.refmerged2 \
      --extract /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.signal_only.prune2.prune.in \
      --make-bed \
      --out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.signal_only2
done







Non-independent SNP sets
case-only2(new reference dataset): /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.refmerged2.bim
case: /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.refmerged2.bim 
case-null: /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.null.refmerged2.bim

cat /home/cvasallo/Documents/gxs_results/selection/*.${case}.case.signal_only.refmerged2.bim | cut -f2 | sort -u > /home/cvasallo/Documents/gxs_results/selection/allchrs.${case}.case.signal_only2.snps

cat /home/cvasallo/Documents/gxs_results/selection/*.${case}.case.refmerged2.bim | cut -f2 | sort -u > /home/cvasallo/Documents/gxs_results/selection/allchrs.${case}.case2.snps
cat /home/cvasallo/Documents/gxs_results/selection/*.${case}.null.refmerged2.bim | cut -f2 | sort -u > /home/cvasallo/Documents/gxs_results/selection/allchrs.${case}.null.snps2


Now, two independet sets are available for this case:
-case-only /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case.signal_only2.bim
- case: /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.case2.bim
- case-null: /home/cvasallo/Documents/gxs_results/selection/chr${chr}.${case}.null2.bim


cat /home/cvasallo/Documents/gxs_results/selection/*.${case}.case.signal_only2.bim | cut -f2 | sort -u > /home/cvasallo/Documents/gxs_results/selection/allchrs.${case}.case.signal_only.indepsnps2

cat /home/cvasallo/Documents/gxs_results/selection/*${case}.case2.bim | cut -f2 | sort -u > /home/cvasallo/Documents/gxs_results/selection/allchrs.${case}.case.indepsnps2

cat /home/cvasallo/Documents/gxs_results/selection/*${case}.null2.bim | cut -f2 | sort -u > /home/cvasallo/Documents/gxs_results/selection/allchrs.${case}.null.indepsnps2



In R, filter ref file to the union of case and case-null SNPs - looping over cases in LDproxy_target.R 



# Create an independent set of reference SNPs to be used for lm and kmeans with the case labels.

for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile ~/Documents/gxs_results/selection/1000G_EUR_Phase3_plink/1000G.EUR.QC.${chr} \
      --extract ${REF_DATASET_SNPS} \
      --make-bed \
      --out  /home/cvasallo/Documents/gxs_results/selection/chr${chr}.refdataset2
done




# LD Prune case set to get indep case SNPs
now 50 5 0.6
for chr in {1..22}
do
~/Downloads/plink_linux_x86_64_20250615/plink \
--bfile /home/cvasallo/Documents/gxs_results/selection/chr${chr}.refdataset2 \
--indep-pairwise 50 5 0.6 \
--out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.refdatasetprune2_2
done



# Extract pruned in and create indep case plink set of all SNPs case or not
for chr in {1..22}; do
~/Downloads/plink_linux_x86_64_20250615/plink \
      --bfile /home/cvasallo/Documents/gxs_results/selection/chr${chr}.refdataset2 \
      --extract /home/cvasallo/Documents/gxs_results/selection/chr${chr}.refdatasetprune2_2.prune.in \
      --make-bed \
      --out /home/cvasallo/Documents/gxs_results/selection/chr${chr}.indeprefdataset2_2
done



# Join all chrs of pruned ref dataset to filter the full all chrs_test_df *(allcases.test.df ) upon analysis or the new ref dataset after adding the case_status using format_ref2.R

full genome indep list at 0.6
cat /home/cvasallo/Documents/gxs_results/selection/*.indeprefdataset2_2.bim | cut -f2 | sort -u > /home/cvasallo/Documents/gxs_results/selection/allchrs.refdataset.indepsnps2_2

cat /home/cvasallo/Documents/gxs_results/selection/allchrs.refdataset.indepsnps2_2 | grep -w -f case4.ids 

Indep dataset at 0.2 intersects caseplusldproxy0.6 files allchrs.${case}.ld_exclude_0.6.txt 
cat /home/cvasallo/Documents/gxs_results/selection/allchrs.refdataset.indepsnps2 | grep -w -f /home/cvasallo/Documents/gxs_results/selection/allchrs.${case}.ld_exclude_0.6.txt 


