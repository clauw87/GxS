RES=$1	
OUTPUTS=$2



# log of ldsc
#RES=../3-preprocess/real/outputs/log.22487536.out
#RES=$(ls ../3-preprocess/real/outputs/log.* | grep out | grep -v err | grep -v messages)

# header
cat $RES | grep -w p1 | grep -w p2 | head -n1 > ./real/tmp/ldsc_res.txt

# rows
#cat $RES | grep gz | grep 0 >> ./real/tmp/ldsc_res.txt 

cat $RES | grep a9f | grep r5f | grep gz | grep 0  >> ./real/tmp/ldsc_res.txt


module load R

Rscript ./real/scripts/get_from_log.R ./real/tmp/ldsc_res.txt $OUTPUTS

