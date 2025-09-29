#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  #clean_directory
  rm -fR real/outputs/*


  # Configuration  
  
  #readlink -f ../1-mr-format/real/outputs/* | grep gz  > ./real/inputs/mr-formatted.list
 
 


# test
  readlink -f ../1-mr-format/real/outputs/* | grep gz | grep r5 | grep -v _tmp > ./real/inputs/mr-formatted.list 
  readlink -f ../1-mr-format/real/outputs/* | grep gz | grep a9 | grep -v _tmp >> ./real/inputs/mr-formatted.list




  SUMSTATS_LIST=./real/inputs/mr-formatted.list

 
  OUTPUT_DIR=./real/outputs

  
  bash ./real/scripts/trait_combinations.sh ${SUMSTATS_LIST}


#exit
 

  # Configuration  

  COMBI_LIST=./real/tmp/phenoscomb
  #COMBI_LIST=./real/tmp/phenoscomb_short


  # COMMAND
  COMMAND=" \
    ./real/scripts/run_lhcMR.sh \
      ${COMBI_LIST} \
      ${OUTPUT_DIR}       
  "
  
  # Execution 
  # Cluster array execution
  JOBS_COUNT=$(cat ${COMBI_LIST} | wc -l)
  eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit

  # Direct execution
  #eval bash ${COMMAND}
  #exit 

  # Cluster execution
  #eval sbatch ${COMMAND}
  #exit             

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
  mkdir real/scrips
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
