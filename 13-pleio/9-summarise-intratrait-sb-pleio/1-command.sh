#!/bin/bash

# Main Code --------------------------------------------------------

main(){

  clean_directory


  OUTPUT_DIR=./real/outputs
  
 
  # all directories in PLEIO clumped
  rm -rf ./real/inputs/codes.txt

  PATHS=$(ls -d ../5-clump/real/outputs/*/)
  for p in ${PATHS}
  do
  echo $p
  basename $p >> ./real/inputs/codes.txt
  done

  # select the correct codes from the full list of trait combinations in both directions
  cat real/inputs/inputs_list.txt | grep -f ./real/inputs/codes.txt  > ./real/inputs/input_list.txt

  


  # Getting existing combi codes
  cp ../3-preprocess/real/tmp/phenoscomb ./real/inputs
  sed 's/ /_/g' ./real/inputs/phenoscomb > ./real/inputs/phenoscomb_


  #module load R
  #Rscript ./real/scripts/traitfmcodes.R ./real/inputs/input_list.txt ./real/inputs/intratrait_codes.txt
 
#exit


# cretaes "./real/inputs/intratrait_codes.txt" file
# with the direction of pleiotropies and the replication boolean to grep easily


    # select the existing ones only
    cat ./real/inputs/intratrait_codes.txt | grep -f ./real/inputs/phenoscomb_ > ./real/inputs/intratrait_codes_.txt



  INPUTS_LIST=./real/inputs/intratrait_codes_.txt

  
  COMMAND=" \
    ./real/scripts/loci.explore.sh \
        ${INPUTS_LIST} \
        ${OUTPUT_DIR} \
  " 




   JOBS_COUNT=$(cat ${INPUTS_LIST} | wc -l)
   sbatch \
      --array=1-${JOBS_COUNT} \
      ${COMMAND}


exit 








}

# FUN  ==========================================================



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
