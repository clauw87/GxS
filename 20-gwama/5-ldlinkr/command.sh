
rm -rf real/outputs/*


#INPUTS_DIR=../2-analyze/real/outputs
#SUFFIX=.sex_diff_iii


INPUTS_DIR=../3-clump/real/outputs
SUFFIX=result.clump.loci.csv

OUTPUTS_DIR=./real/outputs



#ls ${INPUTS_DIR}/*${SUFFIX} | xargs -I {} basename {} | cut -d'.' -f1 > ./real/inputs/codes.txt

ls ${INPUTS_DIR}/*/${SUFFIX} | cut -d "/" -f5 >  ./real/inputs/codes.txt


CODE_LS=$(cat ./real/inputs/codes.txt)


# CANNOT BE RUN IN PARALEL QUERIES

i=0

for CODE in ${CODE_LS[@]}

do

i=$(($i+1))

COMMAND="./real/scripts/run_LDlinkR.sh ${CODE} ${INPUTS_DIR} ${SUFFIX} ${OUTPUTS_DIR}"



if [ $i == 1 ]
then
   JOB_ANTERIOR=$(sbatch --parsable ${COMMAND})
else
   JOB_ANTERIOR=$(sbatch --parsable --dependency=afterok:${JOB_ANTERIOR} ${COMMAND})
fi

done
