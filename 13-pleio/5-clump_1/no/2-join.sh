
CODES=$(ls real/outputs/ | grep -v log)

#CODE='r5m_r5f' 

for CODE in ${CODES}
do
echo $CODE
# join
cat real/outputs/${CODE}/*.clumped | head -n1 > ./real/outputs/${CODE}/${CODE}.clumped
cat real/outputs/${CODE}/*.clumped | grep rs >> ./real/outputs/${CODE}/${CODE}.clumped
done

# count loci
cat ./real/outputs/${CODE}/${CODE}.clumped | grep -v CHR | wc -l 

