# all SNPs
cat real/outputs/r5m:r5f.sex_diff | head -n1 > all
cat real/outputs/*.sex_diff | grep -v -w SNP  >>  all

# iii
cat real/outputs/*.sex_diff_iii | head -n1 > real/outputs/all.iii
cat real/outputs/*.sex_diff_iii | grep -v -w SNP >> real/outputs/all.iii

cat real/outputs/all.iii | cut -f1 | grep -v -w SNP | sort -u > real/outputs/all.sbsnps
