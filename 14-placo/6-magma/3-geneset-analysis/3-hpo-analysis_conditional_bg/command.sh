#!/bin/bash

# Main Code --------------------------------------------------------

main(){

  module load R  
  # Creates and cleans directory structure
  clean_directory
  
  
  # Configuration
  # manually created joblist
    POPULATION=EUR
    BDNAME=HPO
  
  # Configuration
  # manually created joblist  
  ls ../../2-gene-analysis/2-gene-analysis/real/outputs/*.gene.analysis.genes.raw | grep bm | grep AD  > ./real/inputs/jobList.txt
  
  JOBLIST=./real/inputs/jobList.txt

  GENESET=$(basename ./real/inputs/c5.hpo.v2023.2.Hs.entrez.gmt)  
  

  cat ./real/inputs/${GENESET}  | cut --complement  -f1,2 | tr '\n' '\t' > ./real/inputs/all_genes_${GENESET}
  Rscript ./real/scripts/u_genes.R ${GENESET} 
  cat real/inputs/all_unique_${GENESET} | grep -v NA | tr '\n' ' '  > ./real/inputs/background_${GENESET}
 
  GENESETS_FILE=./real/inputs/${GENESET}
  BACKGROUND_FILE=./real/inputs/background_${GENESET}

  cat ${GENESETS_FILE}  > ./real/tmp/${GENESET}.sets
  cat ${BACKGROUND_FILE} >> ./real/tmp/${GENESET}.sets


#exit
    
  #CUSTOME_GENESETS=../1-create-inputs/real/inputs/genesets

  RES_FOLDER=../../2-gene-analysis/2-gene-analysis/real/outputs
  OUTPUT_DIR=./real/outputs
 

  # COMMAND
  COMMAND=" \
    ./real/scripts/jobs.sh \
      ${JOBLIST} \
      ${GENESET} \
      ${RES_FOLDER} \
      ${OUTPUT_DIR} \
      ${POPULATION}
  "

#JOBLIST=$1
#GENESET=$2
#RES_FOLDER=$3
#OUTPUT_DIR=$4
  
# ${CUSTOM_GENESETS} \
 

  # Execution 
  # Cluster array execution
  JOBS_COUNT=$(cat ${JOBLIST} | wc -l)
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
