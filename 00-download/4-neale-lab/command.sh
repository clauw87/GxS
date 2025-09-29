#!/bin/bash


# Main Code --------------------------------------------------------
# Runs 

main(){
  
  # Creates and cleans directory structure
  clean_directory 


  # Configuration
  
  # target list: intercept of Neales high N with 500 or so of DME paper
  #cat real/inputs/bt.txt | tail -n+2 | grep -f ./real/inputs/suppl_data_2_ids.txt | head | cut -f1 > ./real/inputs/target.list
  #cat real/inputs/qt.txt | tail -n+2 | grep -f ./real/inputs/suppl_data_2_ids.txt | head | cut -f1 >> ./real/inputs/target.list
  cat real/inputs/bt.txt | tail -n+2 | grep -f ./real/inputs/interesting.bt | head | cut -f1  > ./real/inputs/target.list
  cat real/inputs/bt.txt | tail -n+2 | grep -f ./real/inputs/interesting.bt | grep Alzh | cut -f1 >> ./real/inputs/target.list
  cat real/inputs/bt.txt | tail -n+2 | grep -f ./real/inputs/interesting.bt | grep Depres | cut -f1 >> ./real/inputs/target.list  
  cat real/inputs/qt.txt | tail -n+2 | grep -f ./real/inputs/interesting.qt | grep score | cut -f1 >> ./real/inputs/target.list
  cat real/inputs/qt.txt | tail -n+2 | grep -f ./real/inputs/interesting.qt | grep Happiness | cut -f1 >> ./real/inputs/target.list
  cat real/inputs/qt.txt | tail -n+2 | grep -f ./real/inputs/interesting.qt | head | cut -f1 >> ./real/inputs/target.list 
 
  
# exit

  # File with downloads paths (wgets from Neales lab)
  INFO=./real/inputs/UKBB_GWAS_Imputed_3_manifest_201807.tsv
  
  # if a limiting target list
  cat ${INFO} |   grep -wf real/inputs/target.list  | cut -f1,6 > ./real/tmp/info_cut
 
  INFO_CUT=./real/tmp/info_cut

 
  # Prepares list of jobs to run
  # For each GWAS
  #while read id File
  #do      
  #  echo $id $File >> ./real/tmp/jobsList.txt    
  #done < ${INFO_CUT}

  cat ./real/tmp/info_cut  > ./real/inputs/jobsList.txt
  
  


  # Limit to gz and non zip and non tar
  #cat ./real/tmp/jobsList.txt | grep gz | grep -v tar | grep -v zip   > ./real/inputs/jobsList.txt


  
  
  COMMAND_F=" \
    ./real/scripts/download_female.sh \
         "

  COMMAND_M=" \
    ./real/scripts/download_male.sh \
         "


  # Execution
  # Cluster execution
  JOBS_COUNT=$(cat ./real/inputs/jobsList.txt | grep -w female | wc -l)
  sbatch --array=1-${JOBS_COUNT} ${COMMAND_F}
  sbatch --array=1-${JOBS_COUNT} ${COMMAND_M}
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
