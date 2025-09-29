ls real/outputs_loop/*.pruned | cut -d"/" -f3 | cut -d "." -f1 > finished_2609.txt
cat real/inputs/joblist_3.txt | grep -v -f finished_2609.txt > real/inputs/joblist_5.txt


cat faltan.txt | grep -v -f loop_current.txt > real/inputs/joblist_5.txt
