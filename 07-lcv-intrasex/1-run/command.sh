#!/bin/bash

# Main Code --------------------------------------------------------

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

   
  # Generate all relevant combinations: here just within-sex
  #bash ./real/scripts/trait_combinations.sh ${SUMSTATS_LIST} ${TMP_DIR} ${INPUTS_DIR}/f.ids ${INPUTS_DIR}/m.ids ${SID_PAIRS} ${MUNGED_DIR} ${FILES_SUFFIX}

 ####### done already #cat real/tmp/phenoscomballmin | grep -v 'ef_' | grep -v 'em_' > ./real/tmp/phenoscomballmin_minuselenas
  
  #cat ./real/tmp/phenoscomballmin_minuselenas | cut -d ' ' -f1  | xargs -I {} basename {} | cut -d '.' -f1 >  ./real/tmp/phenoscomballmin_minuselenas_V1
  #cat ./real/tmp/phenoscomballmin_minuselenas | cut -d ' ' -f2  | xargs -I {} basename {} | cut -d '.' -f1 >  ./real/tmp/phenoscomballmin_minuselenas_V2

  #for file in $(cat ./real/tmp/phenoscomballmin_minuselenas_V1)
  #do
  #echo "../0-munge/real/outputs/"$file".gecko-munged-sumstats.gz" >> ./real/tmp/phenoscomballmin_minuselenas_V1_
  #done

  #for file in $(cat ./real/tmp/phenoscomballmin_minuselenas_V2) 
  #do
  #echo "../0-munge/real/outputs/"$file".gecko-munged-sumstats.gz" >> ./real/tmp/phenoscomballmin_minuselenas_V2_
  #done
  
  #paste  -d ' ' real/tmp/phenoscomballmin_minuselenas_V1_ real/tmp/phenoscomballmin_minuselenas_V2_ > real/tmp/phenoscomballmin_minuselenas_rec
  
 
  #Rscript ./real/scripts/diff.R real/tmp/phenoscomballmin ./real/tmp/phenoscomballmin_minuselenas_rec ./real/tmp/combisnew
      
  #cat ./real/tmp/combisnew | grep -v 'ef_' | grep -v 'em_' > ./real/tmp/combisnew_minus_elena

  #cat ./real/tmp/combisnew |  grep -v -f ./real/tmp/combisnew_minus_elena > ./real/tmp/combisnew_minus_rest   




  OUTPUT_DIR=./real/outputs

   
  #COMBI_LIST=./real/tmp/phenoscomballmin_minuselenas

  COMBI_LIST=./real/tmp/combisnew_minus_elena



  # COMMAND
  COMMAND=" \
    ./real/scripts/run_lcv.sh \
      ${COMBI_LIST} \
      ${OUTPUT_DIR}       
  "


#exit

  
  # Execution 
  # Cluster array execution
  JOBS_COUNT=$(cat ${COMBI_LIST} | wc -l)
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
