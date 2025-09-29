

DOMAINS_LIST=real/inputs/domains.txt


COMMAND="./real/scripts/fil_res.sh ${DOMAINS_LIST}"


NJOBS=$(cat ${DOMAINS_LIST} | wc -l)
sbatch --array=1-${NJOBS} ${COMMAND}
