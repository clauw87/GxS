#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
# Creates and cleans directory structure
clean_directory

# Configuration
RES=../3-join_rg_results/real/outputs/formatted_rg_res.txt
POWERED=../2-join_h2_results/real/outputs/h2_powered_4.txt
METAFILE=../../00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains.txt


COMMAND="./real/scripts/run.sh ${RES} ${POWERED} ${METAFILE}"

sbatch ${COMMAND}
     
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


