


res=($(ls ../3-genesets-analysis_conditional_bg/2-run-model/real/outputs/*.gsa.out))



echo 'trait' 'ngenes' $(cat ${res[0]} | grep -w VARIABLE)> ./real/outputs/results.txt 
for r in ${res[@]}
do
echo $r
#done
echo $(basename $r | sed 's|.geneset.analysis.gsa.out||') $(cat $r | head -n1 | cut -d '=' -f2 | cut -d ' ' -f2) $(cat $r | grep -v '#' |grep -v VARIABLE | grep -v BACKGROUND)  >> ./real/outputs/results.txt
done



