#!/bin/bash

# Main Code --------------------------------------------------------

main(){
   
  rm -rf real/outputs/*

  
   module load R
    
 
   TARGET=../1-run-placo/real/tmp/combination.pairs.minuselenas

   #rm -rf real/inputs/inputs_list.txt


  # Configuration
  # a list of codes as in PLEIO analyses folder names, or pleioFDR, code and code_inv will be checked
  # all directories in PLEIO run outputs

 
  # 41
  #  ls ../1-run-placo/real/outputs_41/*.placo | grep -v "m"  | xargs -I  {} basename {} | sed 's/.placo//g' | tr '_' ':' 
  #ls ../1-run-placo/real/outputs_41/*.placo | grep -v "m"  | xargs -I  {} basename {} | sed 's/.placo//g'  > ./real/inputs/fpairs.txt
  #ls ../1-run-placo/real/outputs_41/*.placo | grep -v "f"  | xargs -I  {} basename {} | sed 's/.placo//g'  > ./real/inputs/mpairs.txt 
  #cat ../../6-sex-differences/2-rg/1-rg-diff/real/outputs/rg_intrasex.txt | awk '{ if ($14=="f") print $0 }' | tail -n +1 | cut -f3,4 | tr '\t' '_' > ./real/inputs/fpairs.txt
  #cat ../../6-sex-differences/2-rg/1-rg-diff/real/outputs/rg_intrasex.txt | awk '{ if ($14=="m") print $0 }' | tail -n +1 | cut -f3,4 | tr '\t' '_' > ./real/inputs/mpairs.txt

  
  # new
  #cat ../1-run-placo/real/tmp/f_phenoscomb | grep -f ../1-run-placo/real/tmp/phenoscomballmin_minuselena | tr ' ' : > ./real/inputs/fpairs.txt
  #cat ../1-run-placo/real/tmp/m_phenoscomb | grep -f ../1-run-placo/real/tmp/phenoscomballmin_minuselena | tr ' ' : > ./real/inputs/mpairs.txt
  
  # newer 
  cat ../1-run-placo/real/tmp/f_phenoscomb | grep -f ${TARGET} | tr ' ' : > ./real/inputs/fpairs.txt
  cat ../1-run-placo/real/tmp/m_phenoscomb | grep -f ${TARGET} | tr ' ' : > ./real/inputs/mpairs.txt


 
  META_FILE=../../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt

  #Rscript real/scripts/create_inputs.R ${META_FILE} ${TARGET}
  
  # real/tmp/intradf.txt # intra trait both sexes, no - PLACO not in very correlated traits
  # real/tmp/crossdf.txt
 
  cat "real/tmp/crossdf.txt" | grep -v f_pair | cut -f3,2 > ./real/inputs/inputs_list.txt     # 1485
  

  #rm -rf ./real/inputs/inputs_list.txt
  #for p in `seq 0 $(( ${#fpairs[@]} - 1 ))`
  #do
  #echo $p
  #echo ${mpairs[p]} ${fpairs[p]} >> ./real/inputs/inputs_list.txt
  #done 
  


  INPUTS_LIST=./real/inputs/inputs_list.txt
  INPUTS_DIR=../1-run-placo/real/outputs
  OUTPUTS_DIR=./real/outputs

  
  # COMMAND
  COMMAND=" \
    ./real/scripts/comparemf.sh \
      ${INPUTS_LIST} \
      ${INPUTS_DIR} \
      ${OUTPUTS_DIR}
  "
  
  # Execution 
 

  # Cluster array execution
  JOBS_COUNT=$(cat ${INPUTS_LIST} | wc -l)
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

main
