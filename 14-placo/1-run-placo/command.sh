#!/bin/bash

# Main Code --------------------------------------------------------

main(){


  # Creates and cleans directory structure
  #clean_directory


  # Configuration

  POWERED=../../02-ldsc/2-join_h2_results/real/outputs/h2_powered_2.txt

   
  INPUTS_DIR=./real/inputs
  TMPS_DIR=./real/tmp


  SID_PAIRS=../../00-download/1-get_traitsinfo/real/outputs/sid.pairs
  cat ../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | grep -w female | cut -f1 | grep -f ${POWERED} > ${INPUTS_DIR}/f.ids
  cat ../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt |  grep -w male | cut -f1 | grep -f ${POWERED}  > ${INPUTS_DIR}/m.ids


  FILES_SUFFIX='.pleio-munged-sumstats.gz'


  MUNGE_DIR=../0-munge/real/outputs
 
   
  #ls ${MUNGE_DIR}/*.gz | grep -f ${POWERED} | xargs -I {} basename "{}" | sed s/'.pleio-munged-sumstats.gz'//g > real/inputs/ids.list
 


  #bash real/scripts/trait_combinations.sh ./real/inputs/ids.list ${TMPS_DIR} ${INPUTS_DIR}/f.ids ${INPUTS_DIR}/m.ids ${SID_PAIRS} ${TMPS_DIR}/combinations.pairs
  

  #INPUT_LIST=${TMPS_DIR}/combination.pairs


  # 2970 wo elena
  #cat ${TMPS_DIR}/combination.pairs | grep -v 'em_' | grep -v 'ef_' >  ${TMPS_DIR}/combination.pairs.minuselenas  

  
  #Rscript real/scripts/diff.R real/tmp/phenoscomballmin ./real/tmp/phenoscomballmin_minuselenas ./real/tmp/combisnew
  #cat ./real/tmp/combisnew | grep -v 'ef_' | grep -v 'em_' > ./real/tmp/combisnew_minus_elena
  #cat ./real/tmp/combisnew |  grep -v -f ./real/tmp/combisnew_minus_elena > ./real/tmp/combisnew_minus_rest
  #INPUT_LIST=./real/tmp/combisnew_minus_elena


  #INPUT_LIST=${TMPS_DIR}/combination.pairs.minuselenas

  # cross cross minus elena
  #cat ${tmpfolder}/phenoscomb | grep -v -f  ${tmpfolder}/phenoscomballmin_minuselenas | grep -v em_ | grep -v ef_ >  ${tmpfolder}/crosscross


  #INPUT_LIST=${TMPS_DIR}/crosscross
 
  # failed
  cat ${TMPS_DIR}/crosscross | grep 4370m | grep bm1f  > real/inputs/failed.txt
  INPUT_LIST=real/inputs/failed.txt


  MUNGE_DIR=../0-munge/real/outputs
  OUTPUTS_DIR=./real/outputs_cross_1


  COMMAND=" \
    ./real/scripts/run_placo.sh \
	${INPUT_LIST} \
	${MUNGE_DIR} \
	${OUTPUTS_DIR} \
        ${FILES_SUFFIX}
  "



  JOBS_COUNT=$(cat "${INPUT_LIST}" | wc -l)
  sbatch \
    --array=1-${JOBS_COUNT} \
    ${COMMAND}
  exit



  # Execution
  # Direct execution
  bash ${COMMAND}
  exit



  # Cluster execution
  JOB1_ID=$(sbatch ${COMMAND})
  exit

  # Cluster after OK
  sbatch \
    --dependency=afterok:${JOB1_ID} \
    ${COMMAND2}
  exit


  # Cluster execution - array
   JOBS_COUNT=$(cat "${SUMSTATS_LIST}" | wc -l)
  sbatch \
    --dependency=afterok:${JOB_ID} \
    --array=1-${JOBS_COUNT} \
    ${COMMAND}
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
