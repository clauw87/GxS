ftp=https://datashare.ed.ac.uk/bitstream/handle/10283/3916


FILE='./download_list'
list=$(cat $FILE | grep -f ../selected_trait_codes.txt | cut -d ' ' -f2)

for name in ${list}
do
echo $name
wget https://datashare.ed.ac.uk/bitstream/handle/10283/3916/${name}
done

