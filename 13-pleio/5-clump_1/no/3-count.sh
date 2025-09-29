CODES=$(ls real/outputs/ | grep -v log)


echo CODE echo loci > loci.counts

for CODE in ${CODES}
do
echo $CODE $(cat ./real/outputs/${CODE}/${CODE}.clumped | grep -v CHR | wc -l)  >> loci.counts 
done
