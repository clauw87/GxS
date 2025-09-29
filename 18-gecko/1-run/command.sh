#!/bin/bash
#


# Main Code --------------------------------------------------------
# Runs 

main(){
 

  # Creates and cleans directory structure
  #clean_directory



  # Configuration
  
  INPUTS_DIR=./real/inputs
  TMP_DIR=./real/tmp


  POWERED=../../02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt 


  MUNGED_DIR=../0-munge/real/outputs
  FILES_SUFFIX='.gecko-munged-sumstats.gz'

 
  SID_PAIRS=../../00-download/1-get_traitsinfo/real/outputs/sid.pairs 
  cat ../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | grep -w female | cut -f1 | grep -f ${POWERED} > ${INPUTS_DIR}/f.ids
  cat ../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt |  grep -w male | cut -f1 | grep -f ${POWERED}  > ${INPUTS_DIR}/m.ids

  ls ${MUNGED_DIR}/*${FILES_SUFFIX} | grep -f ${POWERED}  > ${INPUTS_DIR}/munged-sumstats.list 

  SUMSTATS_LIST=${INPUTS_DIR}/munged-sumstats.list

   
  # Generate all relevant combinations: within-trait and within-sex
  bash ./real/scripts/trait_combinations.sh ${SUMSTATS_LIST} ${TMP_DIR} ${INPUTS_DIR}/f.ids ${INPUTS_DIR}/m.ids ${SID_PAIRS} ${MUNGED_DIR} ${FILES_SUFFIX}

  # the ones done already DO NOT UNCOMMENT
  #cat real/tmp/phenoscomballmin | grep -v 'ef_' | grep -v 'em_' > ./real/tmp/phenoscomballmin_minuselenas

  Rscript ./real/scripts/diff.R real/tmp/phenoscomballmin ./real/tmp/phenoscomballmin_minuselenas ./real/tmp/combisnew
 
  cat ./real/tmp/combisnew | grep -v 'ef_' | grep -v 'em_' > ./real/tmp/combisnew_minus_elena
  cat ./real/tmp/combisnew |  grep -v -f ./real/tmp/combisnew_minus_elena > ./real/tmp/combisnew_minus_rest
  
  




  # Configuration  

  #TRAIT_PAIRS=./real/tmp/phenoscomballmin_minuselenas
  #TRAIT_PAIRS=./real/tmp/combipairs
  #TRAIT_PAIRS=remaning.pairsok
  
  TRAIT_PAIRS=./real/tmp/combisnew_minus_elena

  OUTPUTS_DIR=./real/outputs
  LD_FILE=./real/inputs/ldscores.txt




  # Runs
  COMMAND=" \
    ./real/scripts/run_gecko.sh \
         ${TRAIT_PAIRS} \
         ${OUTPUTS_DIR} \
         ${LD_FILE} \
         ${FILES_SUFFIX}
  "
  
  # Execution      
  ## Cluster execution
  JOBS_COUNT=$(cat ${TRAIT_PAIRS} | wc -l)
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



