
rm -rf real/outputs/*


#ls ../1-run/real/outputs/*.meta.out | grep -v ef_ | grep -v em_ > ./real/inputs/results.txt

ls ../1-run/real/outputs/*.meta.out > ./real/inputs/results.txt


RES_LS=./real/inputs/results.txt


ORI_LS=../1-run/real/inputs/inputs.list

OUTPUTS_DIR=./real/outputs



COMMAND="./real/scripts/run_an.sh ${RES_LS} ${OUTPUTS_DIR}"


NJOBS=$(cat ${RES_LS} | wc -l)


sbatch --array=1-${NJOBS} ${COMMAND}
