
cat real/tmp/crosscross | tr ' ' ':' > target.txt

ls real/outputs_cross/*.placo | xargs -I {} basename {} | cut -d '.' -f1  > done.txt

cat target.txt | grep -v -f done.txt 



# falta 4370m:bm1f
