# Merge with 1000G to restore BP and CHR columns,
# or rather, merge with original formatted ones to also get original Z scores



# raw pleio results

ls ./real/outputs/*/result.clump.loci.csv > ./real/inputs/merge_inputs_list.txt



#RES=./real/outputs/a9f_r5f/result.clump.loci.csv

# pleio results clumped loci
RESULTS=./real/inputs/merge_inputs_list.txt

# munged sumstas
#ORIGIN=./real/tmp/pleio-res*
ORIGIN_FOLDER=./real/tmp


COMMAND="./real/scripts/merge_res.sh $RESULTS ${ORIGIN_FOLDER}
"


  # Execution 
 
 # Cluster array execution
JOBS_COUNT=$(cat ${RESULTS} | wc -l)
eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}
exit
