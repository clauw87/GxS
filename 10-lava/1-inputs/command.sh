#!/bin/bash

# Main Code --------------------------------------------------------

if [ ! -f "./command.sh" ]; then
      cp /homes/users/cvasallo/command.sh ./
fi


main(){


  # Creates and cleans directory structure
  clean_directory
  
 

  # Configuration

  META_FILE=../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt

  POWERED=../../02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt
 

  find $(readlink -f  ../../08-coloc/0-munge/real/outputs/) -iname '*.gz'| grep -f ${POWERED} > ./real/inputs/formatted-sumstats.list

  SUMSTATS_LIST=./real/inputs/formatted-sumstats.list


  COMMAND=" \
    ./real/scripts/run_info.sh \
	${SUMSTATS_LIST} \
        ${META_FILE}
  "



  #JOBS_COUNT=$(cat "${INPUT_LIST}" | wc -l)
  #sbatch \
  #  --array=1-${JOBS_COUNT} \
  #  ${COMMAND}
  #exit


  sbatch ${COMMAND}

exit

  # Execution
  # Direct execution
  #bash ${COMMAND}
  exit



  # Cluster execution
  JOB1_ID=$(sbatch ${COMMAND})
  exit

  # Cluster after OK
  sbatch \
    --dependency=afterok:${JOB1_ID} \
    ${COMMAND2}
  exit


  # Cluster execution - array
   JOBS_COUNT=$(cat "${SUMSTATS_LIST}" | wc -l)
  sbatch \
    --dependency=afterok:${JOB_ID} \
    --array=1-${JOBS_COUNT} \
    ${COMMAND}
  exit









}


























# FUNCTIONS ==========================================================


clean_directory(){
  # Creates and cleans directory structure

  if [ ! -d "real" ]; then

    mkdir real
    mkdir real/scripts
    mkdir real/inputs
    mkdir real/tmp
    mkdir real/outputs

  else

    if [ ! -d "real/scripts" ]; then
  mkdir real/scripts
    fi

    if [ ! -d "real/inputs" ]; then
  mkdir real/inputs
    fi

    if [ ! -d "real/tmp" ]; then
  mkdir real/tmp
    else
  rm -fR real/tmp/*
    fi

    if [ ! -d "real/outputs" ]; then
  mkdir real/outputs
    else
  rm -fR real/outputs/*
    fi

  fi
}


main




  
