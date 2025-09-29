#!/bin/bash

#rm -rf ./real/outputs/*

#ls ../3-clump-pleios/real/tmp/*.gz  > ./real/inputs/joblist.txt
#JOBS_LIST=./real/inputs/joblist.txt
#OUTPUTS_DIR=./real/outputs
#COMMAND="./real/scripts/prune.sh ${JOBS_LIST} ${OUTPUTS_DIR}"
#JOBS_COUNT=$(cat ${JOBS_LIST} | wc -l)
#sbatch --array=1-${JOBS_COUNT} ${COMMAND}



# shared DIS GW
cat ../2-compare-m-f/real/outputs/136m:4212m:137f:4213f/shared_pleios_gw_dis.txt | head -n1 > real/tmp/pooled_shared_pleios_gw_dis.txt
cat ../2-compare-m-f/real/outputs/*/shared_pleios_gw_dis.txt | grep -v -w SNP >> real/tmp/pooled_shared_pleios_gw_dis.txt

# shared CON GW

cat ../2-compare-m-f/real/outputs/r5m:r9m:r5f:r9f/shared_pleios_gw_con.txt | head -n1 > real/tmp/pooled_shared_pleios_gw_con.txt
cat ../2-compare-m-f/real/outputs/*/shared_pleios_gw_con.txt | grep -v -w SNP >> real/tmp/pooled_shared_pleios_gw_con.txt


# excl F GW
cat ../2-compare-m-f/real/outputs/136m:4212m:137f:4213f/gw.exclusive_pleios_f.txt | head -n1 > real/tmp/pooled_excl_pleios_gw_f.txt
cat ../2-compare-m-f/real/outputs/*/gw.exclusive_pleios_f.txt | grep -v -w SNP >> real/tmp/pooled_excl_pleios_gw_f.txt

# excl M GW
cat ../2-compare-m-f/real/outputs/136m:4212m:137f:4213f/gw.exclusive_pleios_m.txt | head -n1 > real/tmp/pooled_excl_pleios_gw_m.txt
cat ../2-compare-m-f/real/outputs/*/gw.exclusive_pleios_m.txt | grep -v -w SNP >>  real/tmp/excl_pleios_gw_m.txt



COMMAND="real/scripts/prune.sh con gw"

#COMMAND="real/scripts/prune.sh dis gw"

sbatch ${COMMAND}
