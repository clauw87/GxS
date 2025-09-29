#!/bin/bash


# Main Code --------------------------------------------------------
# Runs 

main(){
  
  # Creates and cleans directory structure
  clean_directory 


  # Configuration
  
  # File with downloads paths
  #INFO=../../gwas_sources/gwasATLAS_v20191115.txt     

  INFO=../../1-get_traitsinfo/real/inputs/alberts_metadata.txt # selected sex-stratified from Albert

  cat ${INFO} |  cut -f1,2,5 > ./real/tmp/info_cut
 
  INFO_CUT=./real/tmp/info_cut
 
  # Prepares list of jobs to run
  # For each GWAS
  while read id sid File
  do      
    echo $sid $File >> ./real/tmp/jobsList.txt    
  done < ${INFO_CUT}



    # Limit to gz and non zip and non tar
  cat ./real/tmp/jobsList.txt | grep gz | grep -v tar | grep -v zip   > ./real/inputs/jobsList.txt


  
  
  COMMAND=" \
    ./real/scripts/download.sh \
         "


  # Execution
  # Cluster execution
  JOBS_COUNT=$(cat ./real/inputs/jobsList.txt | wc -l)
  sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  exit

  # Direct execution
  bash ${COMMAND}
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
