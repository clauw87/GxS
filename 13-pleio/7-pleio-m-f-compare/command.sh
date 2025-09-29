#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
   module load R
   rm -fR ./real/outputs/*

  # Configuration
  # a list of codes as in PLEIO analyses folder names, or pleioFDR, code and code_inv will be checked
  
  Rscript real/scripts/get_input.R   

  # all directories in PLEIO clumped
  PATHS=$(ls -d ../5-clump/real/outputs/*/)
 
  #rm -rf ./real/inputs/codes.txt

  #for p in ${PATHS}
  #do
  #echo $p
  #basename $p >> ./real/inputs/codes.txt
  #done


 # Rscript real/scripts/get_input.R
#
#exit
  # select the correct codes from the combinations - same combis and done in Rscript now
  #cat real/inputs/inputs_list.txt | grep -f ./real/inputs/codes.txt  > ./real/inputs/input_list.txt
#exit
  #cat ./real/inputs/input_list.txt | tail -n4 > ./real/inputs/input_list_short.txt
  #INPUTS_LIST=./real/inputs/input_list_short.txt
 


  INPUTS_LIST=./real/inputs/inputs_list.txt
  OUTPUT_DIR=./real/outputs

  
  # COMMAND
  COMMAND=" \
    ./real/scripts/compare.sh \
      ${INPUTS_LIST} \
      ${OUTPUT_DIR}
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
