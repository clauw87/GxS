PLINK2

~/Downloads/plink2_linux_avx2_20250627/plink2



bcftools

~/Downloads/bcftools/bcftools



Data


wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20130502.ALL.panel

awk '$3=="EUR" {print $1}' integrated_call_samples_v3.20130502.ALL.panel > eur_samples.txt
awk '$3=="EUR" && $4=="male" {print $1}' integrated_call_samples_v3.20130502.ALL.panel > eur_males.txt
awk '$3=="EUR" && $4=="female" {print $1}' integrated_call_samples_v3.20130502.ALL.panel > eur_females.txt

SNP info
wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5c.20130502.sites.vcf.gz
wget https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5c.20130502.sites.vcf.gz.tbi

download VCFs and limit to EUR samples

for chr in {1..22}; do
  wget -c https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz

  wget -c https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz.tbi

  ~/Downloads/bcftools/bcftools view \
    --samples-file eur_samples.txt \
    --output-type z \
    --output ALL.chr${chr}.EUR.vcf.gz \
 ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz


  ~/Downloads/bcftools/bcftools index ALL.chr${chr}.EUR.vcf.gz

rm ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz 
rm ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz.tbi

done


 



Get sex-stratified AF in EUR with PLINK2

PLINK1 supports --within for group-specific stats. Create a .pheno-style group file:

awk '{print $1, $1}' eur_males.txt > keep_males.keep
awk '{print $1, $1}' eur_females.txt > keep_females.keep
#echo '#FID IID' > eur.keep
cat keep_males.keep keep_females.keep > eur.keep
cat eur.keep | tr ' ' '\t' > eur.keep.tab

#echo '#FID IID CLUSTER' > eur_sex.cluster
awk '$3=="EUR" && $4=="male" {print  $1,  $1, "MALE"}' integrated_call_samples_v3.20130502.ALL.panel > eur_sex.cluster
awk '$3=="EUR" && $4=="female" {print $1, $1, "FEMALE"}' integrated_call_samples_v3.20130502.ALL.panel >> eur_sex.cluster
cat eur_sex.cluster | tr ' ' '\t' > eur_sex.cluster.tab


awk '$3=="EUR" && $4=="male" {print $1,$1,1}' integrated_call_samples_v3.20130502.ALL.panel > sex.txt
awk '$3=="EUR" && $4=="female" {print $1,$1,2}' integrated_call_samples_v3.20130502.ALL.panel >> sex.txt


for chr in {1..22}; do

plink_linux_x86_64_20250615/plink \
  --vcf ALL.chr${chr}.EUR.vcf.gz  \
  --keep eur.keep.tab\
  --maf 0.05 \
  --geno 0.05 \
  --mind 0.05 \
  --snps-only just-acgt \
  --make-bed \
  --out chr${chr}.EUR

for chr in {1..22}; do

~/Downloads/plink2_linux_avx2_20250627/plink2 \
  --bfile chr${chr}.EUR \
  --set-all-var-ids @:#:\$r:\$a \
  --make-bed \
  --out chr${chr}.EUR.id


# update sex
~/Downloads/plink_linux_x86_64_20250615/plink \
  --bfile chr${chr}.EUR.id \
  --update-sex sex.txt \
  --make-bed \
  --out chr${chr}.EUR.sex







~/Downloads/plink_linux_x86_64_20250615/plink \
  --bfile chr${chr}.EUR.sex \
  --within eur_sex.cluster.tab \
  --freq \
  --out chr${chr}.EUR.sexfreq






done
