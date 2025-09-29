rm -rf real/tmp/*
rm -rf real/outputs/*


POWERED=/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt

LOGS_DIR=/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/02-ldsc/3-rg/real/outputs
INPUTS_DIR=./real/inputs
TMPS_DIR=./real/tmp
OUTPUTS_DIR=./real/outputs



cat ../../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | grep -w female | cut -f1 | grep -f ${POWERED} > ${INPUTS_DIR}/f.ids
cat ../../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | grep -w male | cut -f1  | grep -f ${POWERED}> ${INPUTS_DIR}/m.ids




ls -d ${LOGS_DIR}/*.log |  grep -v -f ${INPUTS_DIR}/m.ids > ./real/inputs/female.logs


COMMAND_F="./real/scripts/job.cmd ./real/inputs/female.logs ${INPUTS_DIR} ${TMPS_DIR} ${OUTPUTS_DIR} female"

sbatch ${COMMAND_F}


ls -d ${LOGS_DIR}/*.log | grep -v -f ${INPUTS_DIR}/f.ids > ./real/inputs/male.logs

COMMAND_M="./real/scripts/job.cmd ./real/inputs/male.logs ${INPUTS_DIR} ${TMPS_DIR} ${OUTPUTS_DIR} male"


sbatch ${COMMAND_M}


