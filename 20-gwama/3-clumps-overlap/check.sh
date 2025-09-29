
CODE=ADr1um:ADr1uf 
CODE=a9m:a9f

cat $(ls ./real/outputs/*.overlapped | grep ${CODE} ) | grep -v type

