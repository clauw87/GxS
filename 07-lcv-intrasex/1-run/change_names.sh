RES_LS=$(ls real/outputs/*.results)

for RES in ${RES_LS}

do

echo $RES

NEW_NAME=$(echo ${RES} | sed 's/_/:/g')

no | mv ${RES} ${NEW_NAME}

done

ls ./real/outputs/*.results
