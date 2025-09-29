
CODE1=r5m
CODE2=a9m
INPUTS=./real/inputs
TMP=./real/tmp


# Process files: the formatted files are already aligned anyway

cat ${TMP}/${CODE1}.independent | head -n1 |  cut -f3,4,5,6,14 | tr '\t' ' ' > ${INPUTS}/${CODE1}.input
sed -i 's/SNP A1 A2 BETA PVAL/SNP EA NEA BETA P'/g ${INPUTS}/${CODE1}.input
cat ${TMP}/${CODE1}.independent | tail -n+2 |  cut -f3,4,5,6,14 | tr '\t' ' ' >> ${INPUTS}/${CODE1}.input


cat ${TMP}/${CODE2cat ${TMP}/${CODE2}.independent | head -n1 |  cut -f3,4,5,6,14 | tr '\t' ' ' > ${INPUTS}/${CODE2}.input
sed -i 's/SNP A1 A2 BETA PVAL/SNP EA NEA BETA P'/g ${INPUTS}/${CODE2}.input
cat ${TMP}/${CODE2}.independent | tail -n+2 |  cut -f3,4,5,6,14 | tr '\t' ' ' >> ${INPUTS}/${CODE2}.input



# Prepare a text file named 'filelist.txt' which lists 'dataset1.input' on line 1 and 'dataset2.input' on line 2.



echo ${INPUTS}/${CODE1}.input > filelist_${CODE1}:${CODE2}.txt
echo ${INPUTS}/${CODE2}.input >> filelist_${CODE1}:${CODE2}.txt


# Run 'gwama2.1_SECAalign' program for files in filelist_${CODE1}:${CODE2}.txt
./seca/gwama2.1_SECAalign --filelist filelist_${CODE1}:${CODE2}.txt


# information log: gwama2.1_SECAalign.log.out


# If the SNPs are LD-independent, the 'aligned_effects.txt' file can be renamed/copied to 'independent_aligned_effects.txt' and used as input to 'SECA_Ranalysis.R'
#mv aligned_effects.txt  ${INPUTS}/${CODE1}:${CODE2}.aligened_effects.txt
mv aligned_effects.txt independent_aligned_effects.txt


# Run local installation of 'SECA_Ranalysis.R':
R CMD BATCH seca/SECA_Ranalysis.R

# Run local installation of 'SECA_Ranalysis_HeatmapPerm.R':
R CMD BATCH SECA_Ranalysis_HeatmapPerm.R



