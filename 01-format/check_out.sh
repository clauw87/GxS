FORMAT=coloc

ls real/outputs | grep -v err | grep -v out | grep log | cut -d '.' -f1 > ./real/tmp/id_in.txt
ls real/outputs | grep -v err | grep -v out | grep $FORMAT | cut -d '.' -f1 > ./real/tmp/id_out.txt


cat ./real/tmp/id_in.txt | grep -v -w -f ./real/tmp/id_out.txt > ./real/tmp/id_failed.txt




ls test/outputs | grep -v err | grep -v out | grep log | cut -d '.' -f1 > ./test/tmp/elenas_in.txt
ls test/outputs | grep gz | grep -v mr | cut -d '.' -f1 > test/tmp/elenas_out.txt

cat ./test/tmp/elenas_in.txt | grep -v -w -f test/tmp/elenas_out.txt > test/tmp/elenas_failed.txt
