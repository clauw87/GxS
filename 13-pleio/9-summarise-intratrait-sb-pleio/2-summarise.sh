# Tabulate number of pleios, total pos and neg (if any) between sexes in same trait

   

codes=($(cat ./real/inputs/intratrait_codes_.txt))

echo ${codes[@]}


echo code total total_replicated positive positive_replicated negative negative_replicated > ./real/outputs/summary.txt


for code in ${codes[@]}


do

traitpair=$code
#traitpair=r5f_r5m


#path=../8-pleio-pleioFDR-compare/real/outputs/${traitpair}
path=real/outputs
#
total=$(cat $path/${traitpair}.pleio_dir | grep -v LEAD_SNP | wc -l) # 123
total_replicated=$(cat $path/${traitpair}.pleio_dir  | grep -v LEAD_SNP | grep TRUE | wc -l) # 113


positive=$(cat $path/${traitpair}.pleio_dir  | grep AGONISTIC | wc -l)
positive_replicated=$(cat $path/${traitpair}.pleio_dir  | grep TRUE | grep AGONISTIC | wc -l)

negative=$(cat $path/${traitpair}.pleio_dir | grep ANTAGONISTIC | wc -l)
negative_replicated=$(cat $path/${traitpair}.pleio_dir  | grep TRUE | grep ANTAGONISTIC | wc -l)


echo $code $total $total_replicated  $positive $positive_replicated $negative $negative_replicated >> ./real/outputs/summary.txt


done
