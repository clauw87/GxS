# out vs in


ls real/outputs | grep -v err | grep -v out | grep log | cut -d '.' -f1 > ./real/tmp/id_in.txt
ls real/outputs/*.munged-sumstats.gz | cut -d '/' -f3 | cut -d '.' -f1 > ./real/tmp/id_out.txt
cat ./real/tmp/id_in.txt | grep -v -w -f ./real/tmp/id_out.txt > ./real/tmp/id_failed.txt


