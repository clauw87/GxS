#!/bin/bash

# Main Code --------------------------------------------------------

main(){
  
   module load R

   rm -fR ./real/outputs/*
   rm -rf real/inputs/inputs_list.txt


  # Configuration
  # a list of codes as in PLEIO analyses folder names, or pleioFDR, code and code_inv will be checked
  
 
  # all directories in PLEIO run outputs
  #PATHS=$(ls -d ../5-clump/real/outputs/*/)
  PATHS=$(ls -d ../2-run-pleioFDR/real/outputs/*/)
 

  #for p in ${PATHS}
  #do
  #echo $p
  #basename $p >> ./real/inputs/codes.txt
  #done

  #cat ../../6-sex-differences/2-rg/1-rg-diff/real/outputs/rg_intrasex.txt | awk '{ if ($14=="f") print $0 }' | tail -n +1 | cut -f3,4 | tr '\t' '_' > ./real/inputs/fpairs.txt
  #cat ../../6-sex-differences/2-rg/1-rg-diff/real/outputs/rg_intrasex.txt | awk '{ if ($14=="m") print $0 }' | tail -n +1 | cut -f3,4 | tr '\t' '_' > ./real/inputs/mpairs.txt
  
  
  #ls ../2-run-pleioFDR/real/outputs/*/*_zscore_conjfdr_0.05_loci.csv  > real/inputs/results.txt
  

  # THESE
  #ls ../2-run-pleioFDR/real/outputs/*/*_zscore_conjfdr_0.05_all.csv  > real/inputs/results.txt


  mids=/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/02-ldsc/3-rg/real/inputs/m.ids
  fids=/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/gxs_postgwas/02-ldsc/3-rg/real/inputs/f.ids 
  
   # echo | cut -d'/' -f5  
  
  cat real/inputs/results.txt | grep -v -f ${fids}  > ./real/inputs/mpairs.txt
  cat real/inputs/results.txt | grep -v -f ${mids}  > ./real/inputs/fpairs.txt
  mpairs=($(cat ./real/inputs/mpairs.txt))
  fpairs=($(cat ./real/inputs/fpairs.txt))  

  rm -rf real/inputs/inputs_list.txt
  for p in `seq 0 $(( ${#fpairs[@]} - 1 ))`
  do
  echo $p
  echo ${mpairs[p]} ${fpairs[p]} >> ./real/inputs/inputs_list.txt
  done 
  
  #cat real/inputs/inputs_list.txt | tr ' ' '\t' > real/inputs/inputs_list_.txt 

  INPUTS_LIST=./real/inputs/inputs_list.txt
  OUTPUTS_DIR=./real/outputs


#exit 
  
  # COMMAND
  COMMAND=" \
    ./real/scripts/fmcompare.sh \
      ${INPUTS_LIST} \
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
