#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
  # Creates and cleans directory structure
  clean_directory
  
  mkdir real/inputs/genesets/Sex-biased 
  cat real/inputs/GTEx_sb.txt | cut -f6 | sort -u > ./real/inputs/genesets/Sex-biased/sb.geneset  
  cat real/inputs/GTEx_sb_bg.txt | cut -f45 | sort -u > ./real/inputs/genesets/Sex-biased/sb.background  
 
  
  # Configuration
  # manually created job list
  JOBLIST=./real/inputs/jobList1.txt
  GENESETS_FOLDER=real/inputs/genesets
  OUTPUT_DIR=./real/outputs
  GENESET=Sex-biased

 
#exit
  # COMMAND
  COMMAND=" \
    ./real/scripts/jobs.sh \
      ${JOBLIST} \
      ${GENESETS_FOLDER} \
      ${OUTPUT_DIR} \
      ${GENESET}
  "
  
 

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
