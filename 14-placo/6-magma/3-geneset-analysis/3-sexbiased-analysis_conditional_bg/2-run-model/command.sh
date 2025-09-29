#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory

  cat ../1-create-inputs/real/outputs/r5m_r5f.Sex-biased.background | grep -v NA | sort -u -r | tr '\n' ' ' > ./real/inputs/Sex-biased.background  
  cat ../1-create-inputs/real/outputs/r5m_r5f.Sex-biased.geneset | grep -v NA | sort -u -r | tr '\n' ' ' > ./real/inputs/Sex-biased.geneset

 

 # Configuration
  # manually created joblist
   
  JOBLIST=./real/inputs/jobList.txt

  #GENESET=$(basename ./real/inputs/c8.all.v2023.2.Hs.entrez.gmt)  
  

  GENESET='Sex-biased'    

  #for per database .gmt files
  #GENESET=$(basename ./real/inputs/sb.geneset)
  #cat ./real/inputs/${GENESET}  | cut --complement  -f1,2 | tr '\n' '\t' > ./real/inputs/all_genes_${GENESET}
  #Rscript ./real/scripts/u_genes.R ${GENESET} 
  #cat real/inputs/all_unique_${GENESET} | grep -v NA | tr '\n' ' '  > ./real/inputs/background_${GENESET}
  
  


  # for per trait genesets    
  #CUSTOME_GENESETS=../1-create-inputs/real/inputs/genesets

  RES_FOLDER=../../2-gene-analysis/2-gene-analysis/real/outputs
  OUTPUT_DIR=./real/outputs
 

  # COMMAND
  COMMAND=" \
    ./real/scripts/jobs.sh \
      ${JOBLIST} \
      ${GENESET} \
      ${RES_FOLDER} \
      ${OUTPUT_DIR}        
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
