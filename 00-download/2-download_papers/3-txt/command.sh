#!/bin/bash


# Main Code --------------------------------------------------------
# Runs 

main(){
  
  # Creates and cleans directory structure
  clean_directory 


  # Configuration
  
  # File with downloads paths
 

  INFO=../../1-get_traitsinfo/real/inputs/alberts_metadata.txt

  cat ${INFO} |  cut -f1,5 > ./real/tmp/info_cut
 
  INFO_CUT=./real/tmp/info_cut
 
  # Prepares list of jobs to run
  # For each GWAS
  while read id File
  do      
    echo $id $File >> ./real/tmp/jobsList.txt    
  done < ${INFO_CUT}

    # Limit to plan txt
  cat ./real/tmp/jobsList.txt | grep -v zip | grep -v tar | grep -v gz | grep .tbl  > ./real/inputs/jobsList.txt
  cat ./real/tmp/jobsList.txt | grep -v zip | grep -v tar | grep -v gz | grep .txt  >> ./real/inputs/jobsList.txt
  cat ./real/tmp/jobsList.txt | grep -v zip | grep -v tar | grep -v gz | grep .tsv  >> ./real/inputs/jobsList.txt
  cat ./real/tmp/jobsList.txt | grep -v zip | grep -v tar | grep -v gz | grep .csv  >> ./real/inputs/jobsList.txt

#exit
  
  
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
