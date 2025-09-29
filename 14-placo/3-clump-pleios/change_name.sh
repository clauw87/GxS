FOLDERS=$(ls -d real/outputs/*.gw)

for FOLDER in ${FOLDERS[@]}
do
NEWNAME=$(echo $FOLDER | sed 's/.gw//g')
mv $FOLDER $NEWNAME
done
