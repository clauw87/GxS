# Config

INPUTS_DIR=../2-compare-m-f/real/outputs
OUTPUTS_DIRE=./real/outputs

# codes, dir with placo results
ls -d ${INPUTS_DIR}/*/ | cut -d'/' -f5 > ./real/inputs/codes_with_results.txt

# for code, figure out if the pair has significant DISCORDANT pleios

echo code num_con num_dis > ./real/inputs/code_con_dis.txt
CODES=$(cat ./real/inputs/codes_with_results.txt)
for CODE in ${CODES}
do
CON=$(cat ${INPUTS_DIR}/${CODE}/shared_pleios.txt | grep CONCORDANT | wc -l)
DIS=$(cat ${INPUTS_DIR}/${CODE}/shared_pleios.txt | grep DISCORDANT | wc -l)
#if [ ${DIS} -gt 0 ]
#then
# Write for all
echo ${CODE} ${CON} ${DIS} >> ./real/inputs/code_con_dis.txt
#fi
done

#CODE=1214m_126m_1215f_127f

cat ./real/inputs/code_dis.txt | wc -l # 580 bc of header

# Comparisons with DISCORDANT
cat ./real/inputs/code_dis.txt | grep -v code | grep -v -w 0 | wc -l  # 286


CODES_DIS=$(cat ./real/inputs/code_con_dis.txt | grep -v code | grep -v -w 0 |  cut -f1)
