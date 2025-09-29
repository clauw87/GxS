#!/bin/bash

folder=./downloads_100_all
files=($(ls $folder))

minimumsize=300

#echo "" > ok.txt 

for file in ${files[@]}
do
s=$(du -k ${folder}/${file} | cut -f 1) 
if [ $s -ge $minimumsize ]; then
    echo $file >> ok.txt
fi
done
