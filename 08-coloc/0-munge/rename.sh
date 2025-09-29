
FILES_LS=$(ls real/outputs_gwama/*.gz)

for FILE in ${FILES_LS}

do

mv ${FILE} $(echo ${FILE} | sed 's/.formatted.sumstats.gz//g')


done
