cat real/inputs/sid_pairs.tx | tr '_' ':' > real/tmp/sid_pairs_codes.txt

ls --color=auto real/outputs/*.segbfs.gz | xargs -I {} basename {} | cut -d '.' -f1 > ./real/inputs/done_codes.txt

cat real/tmp/sid_pairs_codes.txt | grep -v -f ./real/inputs/done_codes.txt > ./real/inputs/failed.codes.txt

cat ./real/inputs/failed.codes.txt  | tr ':' '_' > real/inputs/sid_pairs_todo.txt


