ç#!/bin/bash

# Main Code --------------------------------------------------------

if [ ! -f "./command.sh" ]; then
      cp /homes/users/cvasallo/command.sh ./
fi


main(){


  # Creates and cleans directory structure
  #clean_directory

  # female male and "" for both together
  SEX_LIST=./real/inputs/sex.txt
 
  # Configuration


  cat ../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | cut -f1 > real/inputs/meta.sids

  POWERED=../02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt
  ls ../08-coloc/0-munge/real/outputs/*.coloc-munged-sumstats.gz | grep -w -f ${POWERED} | grep -v em_ | grep -v ef_ > ./real/inputs/coloc-munged.files


  INPUTS_DIR=./real/inputs
  TMPS_DIR=./real/tmp
  MUNGES_DIR=../08-coloc/0-munge/real/outputs
  OUTPUTS_DIR=real/outputs  
  INPUTS_LIST=./real/inputs/coloc-munged.files
  FILES_SUFFIX=.coloc-munged-sumstats.gz

  CUT="\
  ./real/scripts/cut.sh \
  ${INPUTS_LIST} \
  ${TMPS_DIR}
  "


  COMMAND=" \
    ./real/scripts/run_hyprcoloc.sh \
	${TMPS_DIR} \
	${SEX_LIST}
  "


  JOBS1_COUNT=$(cat "${INPUTS_LIST}" | wc -l)
  #JOBCUT=$(sbatch --parsable --array=1-${JOBS1_COUNT} ${CUT})

  JOBS_COUNT=$(cat ${SEX_LIST} | wc -l)
  #sbatch --dependency=afterany:${JOBCUT} --array=1-${JOBS_COUNT} ${COMMAND} 
  
  sbatch --array=1-${JOBS_COUNT} ${COMMAND}


  exit




  # Execution
  # Direct execution
  bash ${COMMAND}
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




  
