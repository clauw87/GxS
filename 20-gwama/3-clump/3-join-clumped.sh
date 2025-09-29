

echo CODE,TOTAL,POS,NEG > ./real/outputs/joined-loci.list

cat real/outputs/*/loci.list | grep -v CODE >> ./real/outputs/joined-loci.list


