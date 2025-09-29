


# call python
# python call to plink (FUMA lead SNPs)
## define lead snps using plink
# --clump-p1 Significance threshold for index SNPs
# --clump-p2 Secondary significance threshold for clumped SNPs
# --clump-r2 LD threshold for clumping
# --clump-kb Physical distance threshold for clumping
# --clump-snp-field your snp field must be same than in your assoc file
# --clump-field: p value header

plink --bfile plinkbase --clump result.gwas --clump-snp-field rsid\
--clump-field p.value --clump-p1 0.001 --clump-p2 0.1 \
--clump-r2 0.1 --clump-kb 250 --out assoc

os.system("plink --bfile %s --clump %s --clump-field t-pval --clump-p1 0.00000005 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 250 --out %s" % (bfile, betadiff, outputname)) 

