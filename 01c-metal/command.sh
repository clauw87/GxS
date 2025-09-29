#!/bin/bash

main(){
  
  # Creates and cleans directory structure
  #clean_directory

  # Configuration

DOMAIN=ADr1su.meta 

#DOMAIN=ADr.meta
#DOMAIN=ADr1.meta
#DOMAIN=ADru.meta
#DOMAIN=ADr1u.meta
#DOMAIN=pAD.meta
#DOMAIN=pADu.meta


OUTDIR='./real/outputs'

CONFIG=./real/inputs/config.txt


echo name script > $CONFIG


SEXES=( m f )

for SEX in ${SEXES[@]}

do

echo $SEX

#ls ../01-format/test/outputs/pag${SEX}.formatted.sumstats.gz > ./real/inputs/${DOMAIN}.${SEX}.gwaslist
#ls ../01-format/test/outputs/peg${SEX}lif2.formatted.sumstats.gz >> ./real/inputs/${DOMAIN}.${SEX}.gwaslist

#ls ../01-format/test/outputs/rag${SEX}.formatted.sumstats.gz > ./real/inputs/${DOMAIN}.${SEX}.gwaslist
#ls ../01-format/test/outputs/reg${SEX}.formatted.sumstats.gz >> ./real/inputs/${DOMAIN}.${SEX}.gwaslist

ls ../01-format/test/outputs/rag1${SEX}.formatted.sumstats.gz > ./real/inputs/${DOMAIN}.${SEX}.gwaslist
ls ../01-format/test/outputs/reg1${SEX}.formatted.sumstats.gz >> ./real/inputs/${DOMAIN}.${SEX}.gwaslist

if [ $SEX == "m" ]
then
# illness of the father
   ls ../01-format/test/outputs/20107_10_${SEX}.formatted.sumstats.gz >> ./real/inputs/${DOMAIN}.${SEX}.gwaslist
else
# illness of the mother
  ls ../01-format/test/outputs/20110_10_${SEX}.formatted.sumstats.gz >> ./real/inputs/${DOMAIN}.${SEX}.gwaslist
fi


gwaslistfile=./real/inputs/${DOMAIN}.${SEX}.gwaslist
processfile=./real/tmp/process_${DOMAIN}.${SEX}.txt
insertfile=./real/tmp/insertfile_${DOMAIN}${SEX}.txt
scriptfile=./real/tmp/metal-script_${DOMAIN}${SEX}.txt
metaanalysisname=${DOMAIN}.${SEX}

#echo ${DOMAIN}.${SEX} ./real/inputs/${DOMAIN}.${SEX}.gwaslist >> ./real/inputs/config.txt 


echo -n "" > $processfile
for i in $(seq 1 $(cat $gwaslistfile | wc -l))
do 
echo PROCESS >> $processfile
done


paste $processfile $gwaslistfile > $insertfile
sed -i $'s/\t/ /g' $insertfile


lead='^###ADD_GWASES$'
tail='^###ADDED_GWASES$'
sed -e "/$lead/,/$tail/{ /$lead/{p; r $insertfile
        }; /$tail/p; d }"  ./real/scripts/metal-script.txt > $scriptfile


# ADD OUTFILE NAME
sed -i "s|metaanalysis_name|${OUTDIR}/$metaanalysisname|g" $scriptfile


echo $metaanalysisname $scriptfile >> $CONFIG


done

#exit



CONFIG=./real/inputs/config.txt


  COMMAND=" \
    ./real/scripts/run_metal.sh \
    ${CONFIG} \  
         "


  # Execution
  # Cluster execution

  #sbatch ${COMMAND}

  # Execution 
  # Cluster array execution
  JOBS_COUNT=$(cat ${CONFIG} | grep -v -w name  | wc -l)
  eval sbatch --array=1-${JOBS_COUNT} ${COMMAND}
  #exit

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

