cat real/inputs/indep.loci  | xargs -I {} basename {}  | cut -d '.' -f1 > target.codes

#ls real/outputs_1203/coloc_*.txt

ls real/outputs/coloc_*.txt | xargs -I {} basename {} | sed  's/coloc_//g' | cut -d '.' -f1  > done.codes

cat target.codes | grep -v -f done.codes  > todo.codes
