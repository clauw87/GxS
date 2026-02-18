#!/bin/bash
#


# Main Code --------------------------------------------------------
# Runs

main(){


  # Creates and cleans directory structure
  #clean_directory
  rm -rf real/outputs/*


  # Configuration

  INPUTS_DIR=./real/inputs
  TMPS_DIR=./real/tmp
  #POWERED=../2-join_h2_results/real/outputs/h2_powered_2.txt
  POWERED=../2-join_h2_results/real/outputs/h2_powered_2.txt
  MUNGE_DIR=../1a-munge/real/outputs
  SUFFIX='.munged-sumstats.gz'
  META=../../00-download/1-get_traitsinfo/real/outputs/joined_metadata_domains_updated.txt
  # same cat ../../00-download/1-get_traitsinfo/real/outputs/sid.pairs
  #cat ../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | cut  -f15  | grep -v -w pair_m_f  | sort -u > ${INPUTS_DIR}/sid.pairs
  #cat ../../../gxs_postgwas_new/03-power-calc/real/outputs/joined_metadata_power.txt  | cut  -f15  | grep -v -w pair_m_f  | sort -u   > ${INPUTS_DIR}/sid.pairs
  # column pair_m_f
  cat ${META} | cut  -f15  | grep -v -w pair_m_f  | sort -u > ${INPUTS_DIR}/sid.pairs.ori

  # filter to powered z2 ones, min for rg1
  cat ${INPUTS_DIR}/sid.pairs.ori | grep -f  ${POWERED} > ${INPUTS_DIR}/sid.pairs
  SID_PAIRS=${INPUTS_DIR}/sid.pairs

  #ls -d ../1a-munge/real/outputs/* | grep gz | grep -f ./real/inputs/powered_ids.txt  > ./real/inputs/munged-sumstats.list
  #ls -d ../1b-munge-assoc-in-A1/real/outputs/* | grep gz >> ./real/inputs/munged-sumstats.list 
  #ls ../1a-munge/real/outputs/*.gz | grep -f ${POWERED} | grep -v em | grep -v ef > ${INPUTS_DIR}/munged-sumstats.list 
  cat ${META} | grep -w male | cut -f1 | sort -u > ${INPUTS_DIR}/male.ids
  cat ${META} | grep -w female | cut -f1 | sort -u > ${INPUTS_DIR}/female.ids
  cat ${INPUTS_DIR}/male.ids > ${INPUTS_DIR}/meta.sids
  cat ${INPUTS_DIR}/female.ids >> ${INPUTS_DIR}/meta.sids
  METAS=${INPUTS_DIR}/meta.sids 
  # METAPOWERED ids
  cat ${INPUTS_DIR}/male.ids | grep -f  ${POWERED} > ${INPUTS_DIR}/m.ids
  cat ${INPUTS_DIR}/female.ids | grep -f  ${POWERED} > ${INPUTS_DIR}/f.ids

  ls ../1a-munge/real/outputs/*.gz | grep -f ${METAS} | grep -f ${POWERED} > ${INPUTS_DIR}/munged-sumstats.list 

  SUMSTATS_LIST=${INPUTS_DIR}/munged-sumstats.list

  # Generate all relevant combinations: within-trait and within-sex
  #JOB1="./real/scripts/trait_combinations.sh ${SUMSTATS_LIST} ${TMPS_DIR} ${INPUTS_DIR}/f.ids ${INPUTS_DIR}/m.ids ${SID_PAIRS} ${MUNGE_DIR} ${SUFFIX}"
  #JOB1_ID=$(sbatch ${JOB1})
#exit


# exit
# Go to 1-command.sh
  #Rscript ./real/scripts/diff.R real/tmp/phenoscomballmin ./real/tmp/phenoscomballmin_minuselenas ./real/tmp/combisnew

  # Configuration
  TRAIT_PAIRS=./real/tmp/phenoscomballmin

  cat ./real/tmp/phenoscomballmin | grep ADr1 > real/tmp/redo.txt
  TRAIT_PAIRS=real/tmp/redo.txt

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
  #sbatch --array=1-${JOBS_COUNT} --dependency=afterok:${JOB1_ID} ${COMMAND}
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



