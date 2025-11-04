tmp_dir=csonly099
mkdir ${tmp_dir}

n_pairs=$(cat pairs_pleiofdr.df  | grep -v -f pairs.mf  | wc -l )



for n in $(seq 2 $n_pairs)

do
echo $n


ws1=$(cat pairs_pleiofdr.df | sed -n ${n}p  | cut -f2)
ws2=$(cat pairs_pleiofdr.df | sed -n ${n}p | cut -f3)
cs1=$(cat pairs_pleiofdr.df | sed -n ${n}p  | cut -f4)
cs2=$(cat pairs_pleiofdr.df | sed -n ${n}p  | cut -f5)

# original , all pleiotropies: use strict ns filter for ws as FDR > 0.99
cat real/outputs/$ws1/result.csv | awk -F, '$6 < 0.99 {print $2}' > ${tmp_dir}/$ws1.ws1.pleiosnps
cat real/outputs/$ws2/result.csv | awk -F, '$6 < 0.99 {print $2}'  > ${tmp_dir}/$ws2.ws2.pleiosnps
cat real/outputs/$cs1/result.csv | awk -F, '$6 < 0.05 {print $2}'  > ${tmp_dir}/$cs1.cs1.pleiosnps
cat real/outputs/$cs2/result.csv | awk -F, '$6 < 0.05 {print $2}'  > ${tmp_dir}/$cs2.cs2.pleiosnps
cat ${tmp_dir}/$ws1.ws1.pleiosnps  ${tmp_dir}/$ws2.ws2.pleiosnps > ${tmp_dir}/$ws1.$ws2.ws.pleiosnps
cat ${tmp_dir}/$cs1.cs1.pleiosnps  ${tmp_dir}/$cs2.cs2.pleiosnps > ${tmp_dir}/$cs1.$cs2.cs.pleiosnps

#ws_only
# significant pleios in file 2 (cross sex) not in file 1 (within sex)
grep -Fxv -f ${tmp_dir}/$ws1.$ws2.ws.pleiosnps ${tmp_dir}/$cs1.$cs2.cs.pleiosnps  > ${tmp_dir}/$cs1.$cs2.csonly.pleiosnps

done



