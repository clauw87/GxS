#!/bin/bash

# Main Code --------------------------------------------------------

main(){

  clean_directory

  OUTPUT_DIR=./real/outputs
  
  
  # all directories in PLEIO clumped
   
  #rm -rf ./real/inputs/codes.txt
  #sbatch create_codes.sh 
  #PATHS=$(ls -d ../5-clump/real/outputs/*/)
  #for p in ${PATHS}
  #do
  #echo $p
  #basename $p >> ./real/inputs/codes.txt
  #done


  # select the correct codes from the full list of trait combinations in both directions
  #cat real/inputs/inputs_list.txt | grep -f ./real/inputs/codes.txt  > ./real/inputs/input_list.txt


#exit  
  #cat ./real/inputs/input_list.txt | tail -n 4 > ./real/inputs/input_list_short.txt


  #module load R
  #Rscript ./real/scripts/bet_traits_codes.R ./real/inputs/input_list.txt ./real/inputs/intertrait_codes.txt


  cat ./real/inputs/intertrait_codes.txt | grep -f ../9-summarise-intratrait-sb-pleio/real/inputs/phenoscomb_ > ./real/inputs/intertrait_codes_.txt
  
  #sed 's/f//g' ./real/inputs/intertrait_codes_.txt > ./real/inputs/intertrait.txt
   sed -i 's/m//g' ./real/inputs/intertrait.txt
#exit

  # get the ones in 7-compare only
  ls ../7-pleio-m-f-compare/real/outputs/*/pleioc_loci.txt > real/inputs/7-results.txt

# From here on not necesary since this analysis already has all required columns to grep, skip and move to summarise.sh

# cretaes "./real/inputs/intratrait_codes.txt" file
# with the direction of pleiotropies and the replication boolean to grep easily
  
#  COMMAND=" \
#   ./real/scripts/loci.explore.sh \
#        ${INPUTS_LIST} \
#        ${OUTPUT_DIR} \
#  " 



#   INPUTS_LIST=./real/inputs/intertrait_codes.txt

#   JOBS_COUNT=$(cat ${INPUTS_LIST} | wc -l)
#   sbatch \
#      --array=1-${JOBS_COUNT} \
#      ${COMMAND}


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
