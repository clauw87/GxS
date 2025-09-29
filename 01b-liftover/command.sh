#!/bin/bash


# Main Code --------------------------------------------------------
# Runs 


main(){

#clean_directory

 # Configuration

# ad 
ls ../01-format/test/outputs/peg*.partiallyformatted-sumstats.gz > ./real/inputs/sumstats.hg38
#ls ../01-format/test/outputs/reg*.partiallyformatted-sumstats.gz >> ./real/inputs/sumstats.hg38


SUMSTATS_LIST=./real/inputs/sumstats.hg38

CHR_COLUMN=CHR
BP_COLUMN=BP

#CHR_COLUMN=chromosome
#BP_COLUMN=base_pair_location

GENOME_IN=hg38
GENOME_OUT=hg19

COMMAND=" \
    ./real/scripts/lift.sh \
     ${SUMSTATS_LIST} \
     ${GENOME_IN} \
     ${GENOME_OUT} \
     ${CHR_COLUMN} \
     ${BP_COLUMN} \
         "


  # Execution
  # Cluster execution
  JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)
  sbatch --array=1-${JOBS_COUNT} ${COMMAND}
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



