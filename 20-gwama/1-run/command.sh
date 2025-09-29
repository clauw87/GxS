
#!/bin/bash

# Main Code --------------------------------------------------------

if [ ! -f "./command.sh" ]; then
      cp /homes/users/cvasallo/command.sh ./
fi


main(){


  # Creates and cleans directory structure
  #clean_directory
  

  # Configuration

  INPUTS_DIR=./real/inputs
  TMPS_DIR=./real/tmp
  OUTPUTS_DIR=./real/outputs
  #POWERED=../02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt
 

  # sid pairs -same trait opposite sex sids
  cat ../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | cut  -f15  | grep -v pair  | sort -u   > ${INPUTS_DIR}/sid.pairs 

  SID_PAIRS=${INPUTS_DIR}/sid.pairs 


  SUMSTATS_DIR=../08-coloc/0-munge/real/outputs
  FILES_SUFFIX='.coloc-munged-sumstats.gz'

  PAIRS_LIST=./real/inputs/sid.pairs
  #cat ./real/inputs/sid.pairs | grep 128m > ./real/inputs/sid.pairs_1

  PAIRS_LIST=./real/inputs/sid.pairs

  # Creates inputs list of pairs  m f sumstats

   PRE="./real/scripts/inputs.sh ${SUMSTATS_DIR} ${FILES_SUFFIX} ${PAIRS_LIST} ${INPUTS_DIR}/inputs.list" 
   
   bash ${PRE}


 # Run GWAMA
  COMMAND=" \
    ./real/scripts/run_gwama.sh \
        ${INPUTS_DIR}/inputs.list \
        ${OUTPUTS_DIR}

  "





  # Cluster execution
 
 
  JOBS_COUNT=$(cat "${PAIRS_LIST}" | wc -l)
 

  # Cluster execution - array
  sbatch --array=1-${JOBS_COUNT} ${COMMAND}

 

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




  
