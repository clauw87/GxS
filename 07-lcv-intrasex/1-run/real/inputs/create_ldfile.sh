#

# ldscores
#ls ../02-ldsc/3-rg/real/inputs/eur_w_ld_chr/*.gz | grep -v old > ./real/inputs/ldscores.txt
#ldscores=./real/inputs/ldscores.txt
#for ld in $(cat $ldscores) 


for i in $(seq 1 22)
do
echo $i
if [ $i == 1 ]
then
    echo primer
    zcat ../02-ldsc/3-rg/real/inputs/eur_w_ld_chr/${i}.l2.ldscore.gz   > ./real/inputs/ldscores.txt
else
    echo "else"
    zcat ../02-ldsc/3-rg/real/inputs/eur_w_ld_chr/${i}.l2.ldscore.gz | grep -v -w L2  >> ./real/inputs/ldscores.txt
fi
done



# ----------------
