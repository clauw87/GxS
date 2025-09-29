#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J formmetal
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address


ARRAY_LIST=$1



# Array Dependent Config
# If there is no array number assigned:
#   - that means that the script is being executed directly.
#   - it takes the first item of the list as a parameter
# If there is an array number assigned:
#   - that means that the script is being executed through the cluster
#   - it takes the item correspondent to the array number
if [ "${SLURM_ARRAY_TASK_ID}" == "" ]
then
    W=1
else
    W=${SLURM_ARRAY_TASK_ID}
fi


DOMAIN=$(cat ${ARRAY_LIST} | sed -n ${W}p )

 
  
  # Calculate meta BETA and SE - nah will in formatting 
  #Rscript ./real/scripts/beta_and_se.R



  # Compress and reformate sumstats names
  find ./real/outputs/ -name "${DOMAIN}*tbl"   > ./real/inputs/metal-sumstats.list.${DOMAIN}
  #find ./real/outputs/ -name "${DOMAIN}*unfiltered" > ./real/inputs/metal-sumstats.list.${DOMAIN}

  SUMSTATS_LIST_ORI=./real/inputs/metal-sumstats.list.${DOMAIN}

  for SUMSTATS in $(cat ${SUMSTATS_LIST_ORI})
  do
  mv ${SUMSTATS}  ${SUMSTATS}.unfil
  cat ${SUMSTATS}.unfil | awk '{ if ($16> 1e-04) print$0}' > ${SUMSTATS}
  #cat ${SUMSTATS} |  awk '{ if ($16> 1e-04) print$0}' > ${SUMSTATS}
  
  #cat ${SUMSTATS} | awk '{ if ( $8 == "++" || $8 == "--") print$0}' 
  gzip ${SUMSTATS}
  mv ${SUMSTATS}.gz $(echo ${SUMSTATS}.gz | sed "s/1.tbl//g")

  done

  # update file names to avoid "."
  DOMAIN_CODE=$(echo ${DOMAIN} | sed 's/.meta//')
  mv ./real/outputs/${DOMAIN_CODE}.meta.f.gz ./real/outputs/${DOMAIN_CODE}f.meta.gz
  mv ./real/outputs/${DOMAIN_CODE}.meta.m.gz ./real/outputs/${DOMAIN_CODE}m.meta.gz
  

   #mv to 01 format
  #find ../../1-runMETAL/real/outputs/ -name "*txt.gz" > ./real/inputs/sumstats.list

