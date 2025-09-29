#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory
  
  
  # Configuration
 
  GS=go.mf  
 
 
  GENESET=$(basename ./real/inputs/c5.${GS}.v2023.1.Hs.entrez.gmt)  
  cat ./real/inputs/${GENESET}  | cut --complement  -f1,2 | tr '\n' '\t' > ./real/inputs/all_genes_${GENESET}
  Rscript ./real/scripts/u_genes.R ${GENESET} 
  cat real/inputs/all_unique_${GENESET} | grep -v NA | tr '\n' ' '  > ./real/inputs/background_${GENESET}

   
  #CUSTOME_GENESETS=../1-create-inputs/real/inputs/genesets

  RES_FOLDER=../../2-gene-analysis/2-gene-analysis/real/outputs
  OUTPUT_DIR=./real/outputs
 

 
  RESCODES=$(ls ../../../2-analyze/real/outputs/*.sex_diff | xargs -I {} basename {} | cut -d '.' -f1)

  rm -rf ./real/inputs/jobList.txt 


  for CODE in ${RESCODES} 
  do
  echo $GENESET $(ls ../../../2-analyze/real/outputs/${CODE}.sex_diff ) >>  ./real/inputs/jobList.txt
  done


  JOBLIST=./real/inputs/jobList.txt

  # COMMAND
  COMMAND=" \
    ./real/scripts/jobs.sh \
      ${JOBLIST} \
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
