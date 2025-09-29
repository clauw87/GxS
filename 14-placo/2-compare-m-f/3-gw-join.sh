cat real/outputs/*/gw_pleios.txt | cut -f1 | grep -v SNP | sort -u > all.gw.pleios

cat real/outputs/a7m:l1m:a7f:l1f/gw_pleios.txt | head -n1  |  cut -f1,2,3,11,12,18,19,20,31,32,38,39,42,44 > ./real/outputs/joined.gw.pleios.txt
cat real/outputs/*/gw_pleios.txt |  cut -f1,2,3,11,12,18,19,20,31,32,38,39,42,44 >> ./real/outputs/joined.gw.pleios.txt



Rscript ./real/script/conc_dis.R



