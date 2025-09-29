#!/bin/bash


# Main Code --------------------------------------------------------
# Runs 

main(){
  
  # Creates and cleans directory structure
  clean_directory 


  # Configuration
  
  # File with downloads paths
  INFO=/gpfs42/projects/lab_anavarro/disease_pleiotropies/primate_traits/gwas_sources/gwasATLAS_v20191115.txt


  # Filter to female codes in file
  CODES_F=./real/inputs/gwas_ids_f.txt 
  awk 'FNR==NR { a[$1]; next } { print > ($1 in a ? "./real/inputs/info-filtered_f.txt" : "./real/tmp/no") }' ${CODES_F} $INFO
  INFO_F=./real/inputs/info-filtered_f.txt

  # Limit to used columns hereon 
  cat ${INFO_F} |  cut -f1,4 > ./real/tmp/info_cut_f
  INFO_CUT_F=./real/tmp/info_cut_f

  # Prepares list of jobs to run
  # For each GWAS
  while read id File
  do      
    echo $id $File >> ./real/tmp/jobsList_f.txt    
  done < ${INFO_CUT_F}

    # Limit to gz and non zip and non tar
  cat ./real/tmp/jobsList_f.txt | grep gz | grep -v tar | grep -v zip   > ./real/inputs/jobsList_f.txt



  # Filter to codes in file
  CODES_M=./real/inputs/gwas_ids_m.txt
  awk 'FNR==NR { a[$1]; next } { print > ($1 in a ? "./real/inputs/info-filtered_m.txt" : "./real/tmp/no") }' ${CODES_M} $INFO
  INFO_M=./real/inputs/info-filtered_m.txt

  # Limit to used columns hereon 
  cat ${INFO_M} |  cut -f1,4 > ./real/tmp/info_cut_m
  INFO_CUT_M=./real/tmp/info_cut_m

  # Prepares list of jobs to run
  # For each GWAS
  while read id File
  do
    echo $id $File >> ./real/tmp/jobsList_m.txt
  done < ${INFO_CUT_M}

    # Limit to gz and non zip and non tar
  cat ./real/tmp/jobsList_m.txt | grep gz | grep -v tar | grep -v zip   > ./real/inputs/jobsList_m.txt



  
  COMMAND_F=" \
    ./real/scripts/download_female.sh \
         "

  COMMAND_M=" \
    ./real/scripts/download_male.sh \
         "


  

  # Execution
  # Cluster execution
  JOBS_COUNT_F=$(cat ./real/inputs/jobsList_f.txt | wc -l)
  sbatch --array=1-${JOBS_COUNT_F} ${COMMAND_F}
  JOBS_COUNT_M=$(cat ./real/inputs/jobsList_m.txt | wc -l)
  sbatch --array=1-${JOBS_COUNT_M} ${COMMAND_M}

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
