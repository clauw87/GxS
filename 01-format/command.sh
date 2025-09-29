#!/bin/bash

# Main Code --------------------------------------------------------

main(){

exit

  #rm -fR ./real/outputs/*


  # Configuration

  TYPE_FORMAT='general'
  POPULAT=EUR


  # before:
  # 46 traits/diseases hachathon
  # cat /gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/3-power-calc/real/outputs/metadata_power.txt | cut -f1 | tail -n +2 > real/inputs/46.txt
  # plus covid and lipids ones

  # now

  # ids : atlas, alberts, elenas, neales icd10
  cat ../00-download/1-get_traitsinfo/real/outputs/joined_metadata.txt | cut -f1 |  tail -n+2 | sort -u | grep -v -w 102f | grep -v -w 103m  > ./real/inputs/selected.ids
  SEL=./real/inputs/selected.ids

  # paths

  # atlas : 60
  find $(readlink -f ../00-download/3-download-gwasatlas_best/) -iname '*.gz' | grep outputs | grep -f ${SEL}  > ./real/inputs/sumstats.list

  # neales: 18
  find $(readlink -f ../00-download/4-neale-lab_2/) -iname '*.gz' | grep outputs | grep -f ${SEL}  >> ./real/inputs/sumstats.list

  # papers # 24
 
  find $(readlink -f ../00-download/2-download_papers/)  -iname '*.gz' | grep outputs | grep -f ${SEL} >> ./real/inputs/sumstats.list
   
  # requested # 12
  find $(readlink -f ../00-download/6-requests/) -iname '*.gz' | grep outputs | grep -f ${SEL}  >> ./real/inputs/sumstats.list


  # cancer ones (lifted over from intermediate): 6
  find $(readlink -f ../01-liftover/real/outputs/) -iname '*.gz' | grep outputs | grep -f ${SEL}  >> ./real/inputs/sumstats.list

  # selected elena's ones: 326
  find $(readlink -f  ../00-download/5-elena/) -iname '*.gz' | grep -v regenie | grep -v comparison | grep -f ${SEL}  >> ./real/inputs/sumstats.list
  
  # lipids  : 10
  find $(readlink -f ../00-download/7-lipids/) -iname '*.gz' | grep outputs |  grep -f ${SEL} >> ./real/inputs/sumstats.list

#exit


  SUMSTATS_LIST=./real/inputs/sumstats.list

  COLUMNS_INFO=./real/inputs/traitsInfo.tsv
  REF_FILE=/gpfs42/projects/lab_anavarro/disease_pleiotropies/reference/format_ref/real/outputs/1000G.${POPULAT}.ref.gz
  OUTPUT_DIR=./real/outputs
  CHR22_REF=./real/inputs/chr22-snps-by-build/
  
  #TYPE_RUN = 'interm'
  TYPE_RUN = 'normal'
  
  # COMMAND
  COMMAND=" \
    ./real/scripts/format.sh \
      ${SUMSTATS_LIST} \
      ${POPULAT} \
      ${REF_FILE} \
      ${COLUMNS_INFO} \ 
      ${TYPE_FORMAT} \
      ${OUTPUT_DIR} \
      ${CHR22_REF} \
      ${TYPE_RUN}
  "
  
  # Execution 

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
