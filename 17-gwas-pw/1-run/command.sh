
#!/bin/bash

# Main Code --------------------------------------------------------

if [ ! -f "./command.sh" ]; then
      cp /homes/users/cvasallo/command.sh ./
fi


main(){

  #cat ../../14-placo/1-run-placo/real/tmp/combination.pairs.minuselenas | tr ' ' ':' > real/inputs/target.txt
  #TARGET=real/inputs/target.txt

  #TARGET=../../14-placo/1-run-placo/real/tmp/combisnew_minus_elena  
  
  # new
  #cat ../14-placo/1-run-placo/real/tmp/f_phenoscomb | grep -f ${TARGET} | tr ' ' : > ./real/inputs/fpairs.txt
  #cat ../14-placo/1-run-placo/real/tmp/m_phenoscomb | grep -f ${TARGET} | tr ' ' : > ./real/inputs/mpairs.txt
  

  META_FILE=../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt

 
  # Creates and cleans directory structure
  #clean_directory
  
  # Configuration

  BED_FILE=./real/inputs/ldetect-data/EUR/fourier_ls-all_ordered_ok.bed



  # 41 pilot
  #cat ../14-placo/3-clump-pleios/real/inputs/input_pairs.txt  > ./real/inputs/sid_pairs.txt

  # new
  #cat ../14-placo/2-compare-m-f/real/inputs/fpairs.txt > ./real/inputs/sid_pairs_new.txt
  #cat ../14-placo/2-compare-m-f/real/inputs/mpairs.txt >> ./real/inputs/sid_pairs_new.txt


  SUMSTATS_DIR=../../08-coloc/0-munge/real/outputs
  FILES_SUFFIX='.coloc-munged-sumstats.gz'
  ls ${SUMSTATS_DIR}/*${FILES_SUFFIX} > ./real/inputs/sumstats.list
 

  #PAIRS_LIST=./real/inputs/sid_pairs_todo.txt
  #PAIRS_LIST=./real/inputs/sid_pairs_new.txt

  PAIRS_LIST=sid_pairs_undone_.txt

  
  INPUTS_DIR=./real/inputs
  TMPS_DIR=./real/tmp
  OUTPUTS_DIR=./real/outputs
    
  
  COMMAND1=" \
    ./real/scripts/run_merge.sh \
	${PAIRS_LIST} \
	${SUMSTATS_DIR} \
	${TMPS_DIR} \
        ${FILES_SUFFIX}
  "
   


  COMMAND2="./real/scripts/job2.sh ${TMPS_DIR} ${INPUTS_DIR}/inputs.list ${PAIRS_LIST}"
  
  # removes positions from tmp files that are nor in bed_file - otherwise an error is produced
  COMMAND3="./real/scripts/filter.sh ${INPUTS_DIR}/inputs.list ${BED_FILE} ${TMPS_DIR}"  
 

  COMMAND4=" \
    ./real/scripts/gwas_pw.sh \
        ${INPUTS_DIR}/inputs.list \
        ${INPUTS_DIR} \
        ${TMPS_DIR} \
        ${OUTPUTS_DIR}
  "




  # Cluster execution

  # applies to jobs 1,3 and 4
  JOBS_COUNT=$(cat "${PAIRS_LIST}" | wc -l)


 # JOB1----
  
  JOB1_ID=$(sbatch --parsable --array=1-${JOBS_COUNT} ${COMMAND1})

# JOB2----
  JOB2_ID=$(sbatch --parsable --dependency=afterok:${JOB1_ID} ${COMMAND2})


# JOB3----
  JOB3_ID=$(sbatch --parsable --dependency=afterok:${JOB2_ID} --array=1-${JOBS_COUNT} ${COMMAND3})

  #sbatch --array=1-${JOBS_COUNT} ${COMMAND3}
  
# JOB4----
  # Cluster execution - array 
  sbatch --dependency=afterany:${JOB3_ID} --array=1-${JOBS_COUNT} ${COMMAND4}

  #sbatch --array=1-${JOBS_COUNT} ${COMMAND4}


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




  
