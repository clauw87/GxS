#!/bin/bash

# Main Code --------------------------------------------------------

main(){


exit


  # 46 from hachathon for now
  cat /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/3-power-calc/real/outputs/metadata_power.txt | cut -f1 | tail -n +2 > real/inputs/46.txt



  # Configuration
  
  
  #SUMSTATS_LIST=./real/inputs/sumstats.list
    
  find $(readlink -f ../../0-download/) -iname '*.gz' | grep outputs | grep -v cade  | grep -v _noukbb  | grep -v no_  | grep -f ./real/inputs/46.txt  > ./real/inputs/sumstats.list
  
 
  SUMSTATS_LIST=./real/inputs/sumstats.list


  SNPS_FILE=./real/inputs/1000G-SNPs.ref.gz
   
  #SNPS_FILE=./real/inputs/1000G_Phase3_EUR.tsv.gz  
  #SNPS_FILE=./real/inputs/1000G_Phase3_EAS.tsv.gz

  #COLUMNS_INFO=./real/inputs/traitsInfo.tsv # contains GWASAtlas automatically downloaded plus GWASCatalog and plifespan & metaanalysis GWAS entered manually
  COLUMNS_INFO=../../1-mr-format/real/inputs/traitsInfo.tsv
  
     # Eva's file
  #ALLELE_FREQ_FILE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/FertilityPleiotropies/17_Allele_Frequency/03-1000G-Phase3/01-EUR/outputs/EUR_1000GPhase3_AlleleFreq_AllChr.tsv.gz

 
 # LDSC's file (see README) 
  ALLELE_FREQ_FILE=./real/inputs/EUR.1000G.frq.gz
  #ALLELE_FREQ_FILE=./real/inputs/EAS.1000G.frq.gz
   


  OUTPUT_DIR=./real/outputs
  CHR22_REF=./real/inputs/chr22-snps-by-build/    

  FORMAT_TYPE='pleio'

  
  # COMMAND
  COMMAND=" \
    ./real/scripts/format.sh \
      ${SUMSTATS_LIST} \
      ${SNPS_FILE} \
      ${COLUMNS_INFO} \ 
      ${ALLELE_FREQ_FILE} \
      ${FORMAT_TYPE} \
      ${OUTPUT_DIR} \
      ${CHR22_REF}
  "
  
  # Execution 
  rm -fR ./real/outputs/*

  # Cluster array execution
  JOBS_COUNT=$(cat ${SUMSTATS_LIST} | wc -l)
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
