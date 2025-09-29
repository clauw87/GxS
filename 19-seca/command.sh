
#!/bin/bash

# Main Code --------------------------------------------------------

if [ ! -f "./command.sh" ]; then
      cp /homes/users/cvasallo/command.sh ./
fi


main(){

#exit


  # Creates and cleans directory structure
  #clean_directory
  
 

  # Configuration
  POWERED=../02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt

  INPUTS_DIR=./real/inputs
  TMPS_DIR=./real/tmp
  OUTPUTS_DIR=./real/outputs


  SUMSTATS_DIR=../08-coloc/0-munge/real/outputs
  FILES_SUFFIX='.coloc-munged-sumstats.gz'
 
  # pairs male, first
  cat ../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | cut  -f15  | grep -v -w pair  | grep -f ${POWERED} | sort -u | grep -v em_ | grep -v ef_> ${INPUTS_DIR}/sid.pairs
  SID_PAIRS=${INPUTS_DIR}/sid.pairs
 
  cat ../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | cut  -f15  | grep -v -w pair  | grep -f ${POWERED} | cut -d ' ' -f1 | sort -u | grep -v ef_ > real/inputs/f.sids
  cat ../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | cut  -f15  | grep -v -w pair  | grep -f ${POWERED} | cut -d ' ' -f2 | sort -u | grep -v em_> ./real/inputs/m.sids 
   

  
  ls ${SUMSTATS_DIR}/*${FILES_SUFFIX} | grep -f ${POWERED} | grep -v em | grep -v ef > ./real/inputs/sumstats.list
  SUMSTATS_LIST=./real/inputs/sumstats.list
   

  #bash real/scripts/trait_combinations.sh ${SUMSTATS_LIST} ${TMPS_DIR} ${INPUTS_DIR}/m.sids ${INPUTS_DIR}/f.sids ${INPUTS_DIR}/sid.pairs ${SUMSTATS_DIR} ${FILES_SUFFIX}
   

  #combipairs.
  
  cat ${INPUTS_DIR}/sid.pairs | tr ' ' ':' > real/inputs/pairs.list

  PAIRS_LIST=real/inputs/pairs.list
    

  # zcat 
  COMMAND0="./real/scripts/zcat.sh ${SUMSTATS_LIST} ${INPUTS_DIR}"


  # clumping pairs
  COMMAND1=" \
    ./real/scripts/clump_P_dir1.sh \
	${PAIRS_LIST} \
        ${TMPS_DIR}
  "


  # list merged files
  COMMAND2="./real/scripts/job2.sh ${TMPS_DIR} ${INPUTS_DIR}/inputs.list"



 # Run seca on merged files
  COMMAND3=" \
    ./real/scripts/run_seca.sh \
        ${INPUTS_DIR}/inputs.list \
        ${OUTPUTS_DIR}

  "





  # Cluster execution
  #S_COUNT=$(cat ${SUMSTATS_LIST} | wc -l) 
 
  #JOB0_ID=$(sbatch --parsable --array=1-${S_COUNT} ${COMMAND0})

#exit


  JOBS_COUNT=$(cat "${PAIRS_LIST}" | wc -l)
 
  # clump and merge
  #JOB1_ID=$(sbatch --parsable --dependency=afterany:${JOB0_ID} --array=1-${JOBS_COUNT} ${COMMAND1})

  JOB1_ID=$(sbatch --parsable --array=1-${JOBS_COUNT} ${COMMAND1})

 
  # create list of jobs files
  JOB2_ID=$(sbatch --parsable --dependency=afterany:${JOB1_ID} ${COMMAND2})
 
  #JOB2_ID=$(sbatch --parsable ${COMMAND2})


  #sbatch --array=1-${JOBS_COUNT} ${COMMAND3}

  # Cluster execution - array
  sbatch \
    --dependency=afterany:${JOB2_ID} \
    --array=1-${JOBS_COUNT} \
    ${COMMAND3}

 

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




  
