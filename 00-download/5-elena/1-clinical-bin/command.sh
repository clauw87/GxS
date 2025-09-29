ftp=https://datashare.ed.ac.uk/bitstream/handle/10283/3915
FILE='./download_list'
list=$(cat $FILE | grep -f ../selected_clinical_folders.txt | cut -d ' ' -f2 | head -n1)



#for letter in {A..N}
for name in $list
do
echo $letter
#wget ${ftp}/Clinical_${letter}.zip
wget ${ftp}/${name}
done





