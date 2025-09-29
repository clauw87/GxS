#!/bin/bash
#


# Main Code --------------------------------------------------------
# Runs 

main(){
 

  # Creates and cleans directory structure
  #clean_directory

  # Configuration
  
  INPUTS_DIR=./real/inputs
  TMPS_DIR=./real/tmp


  POWERED=../2-join_h2_results/real/outputs/h2_powered_2.txt

  MUNGE_DIR=../1a-munge/real/outputs
  SUFFIX='.munged-sumstats.gz'
  
  # same cat ../../00-download/1-get_traitsinfo/real/outputs/sid.pairs
  cat ../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | cut  -f14  | grep -v -w pair  | sort -u > ${INPUTS_DIR}/sid.pairs

  SID_PAIRS=${INPUTS_DIR}/sid.pairs
  
  #echo ADr1u.f ADr1u.m >> ${INPUTS_DIR}/sid.pairs

  cat ../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | grep -w female | cut -f1 | grep -f ${POWERED} > ${INPUTS_DIR}/f.ids
  
  cat ../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt |  grep -w male | cut -f1 | grep -f ${POWERED}  > ${INPUTS_DIR}/m.ids
  
  #echo ADr1u.f >> ${INPUTS_DIR}.f.ids
  #echo ADr1u.m >> ${INPUTS_DIR}.m.ids


  #ls -d ../1a-munge/real/outputs/* | grep gz | grep -f ./real/inputs/powered_ids.txt  > ./real/inputs/munged-sumstats.list
  #ls -d ../1b-munge-assoc-in-A1/real/outputs/* | grep gz >> ./real/inputs/munged-sumstats.list 


  
  ls ../1a-munge/real/outputs/*.gz | grep -f ${POWERED} | grep -v em | grep -v ef > ${INPUTS_DIR}/munged-sumstats.list 


  SUMSTATS_LIST=${INPUTS_DIR}/munged-sumstats.list

 

  
  # Generate all relevant combinations: within-trait and within-sex
  #JOB1="./real/scripts/trait_combinations.sh ${SUMSTATS_LIST} ${TMPS_DIR} ${INPUTS_DIR}/f.ids ${INPUTS_DIR}/m.ids ${SID_PAIRS} ${MUNGE_DIR} ${SUFFIX}"

  #sbatch ${JOB1}


#exit


  #cat real/tmp/phenoscomballmin | grep -v 'ef_' | grep -v 'em_' > ./real/tmp/phenoscomballmin_minuselenas
 
  # but previously done
  #memory error
  #cat real/tmp/phenoscomballmin | grep -v -f ./real/tmp/phenoscomballmin_minuselenas > ./real/tmp/combisnew
   
  #Rscript ./real/scripts/diff.R real/tmp/phenoscomballmin ./real/tmp/phenoscomballmin_minuselenas ./real/tmp/combisnew
  
  #cat ./real/tmp/combisnew | grep -v 'ef_' | grep -v 'em_' > ./real/tmp/combisnew_minus_elena
  #cat ./real/tmp/combisnew |  grep -v -f ./real/tmp/combisnew_minus_elena > ./real/tmp/combisnew_minus_rest


  # Configuration  
  #TRAIT_PAIRS=./real/tmp/phenoscomballmin_minuselenas
  #cat ./real/tmp/phenoscomballmin_minuselenas | grep c1 > todo.txt
  #cat ./real/tmp/phenoscomballmin_minuselenas | grep c2 >> todo.txt
  #cat ./real/tmp/phenoscomballmin_minuselenas | grep c3 >> todo.txt



  #TRAIT_PAIRS=./real/tmp/combisnew_minus_elena

   TRAIT_PAIRS=./real/tmp/crosscross


  LDSC_OUTPUT_DIR=./real/outputs
  EUR_REFERENCE=./real/inputs/eur_w_ld_chr/




  # Runs
  COMMAND=" \
    ./real/scripts/LDSCgenCorr.sh \
         ${TRAIT_PAIRS} \
         ${LDSC_OUTPUT_DIR} \
         ${EUR_REFERENCE}
  "
  
  # Execution      
  # Cluster execution
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



