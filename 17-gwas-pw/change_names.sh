RES_LS=$(ls ../08-coloc/0-munge/real/outputs/*.formatted.sumstats.gz.coloc-munged-sumstats.gz)

for RES in ${RES_LS}

do

echo $RES

NEW_NAME=$(echo ${RES} | sed 's/.formatted.sumstats.gz//g')

mv ${RES} ${NEW_NAME}

done

ls ./real/outputs/*.results
