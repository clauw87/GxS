#!/bin/bash
#SBATCH --job-name=combi
#SBATCH --output=./real/outputs/out.out
#SBATCH --error=./real/outputs/err.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=64GB

# mail alert at start, end and abortion of execution
#SBATCH --mail-type=END
#SBATCH --mail-user=claudia.vasallo@upf.edu



inputfile=$1
tmpfolder=$2
female_ids=$3
male_ids=$4
pairs_ids=$5
munge_dir=$6
suffix=$7


# Get combinations of pairs of traits to analyse


phenos=(`cat ${inputfile} | cut -f1 `) 


awk -f ./real/scripts/combinations.awk <<< ${phenos[@]} > ./${tmpfolder}/phenoscomb



#list of pairs with self 
rm -rf ${tmpfolder}/phenosself
for p in ${phenos[@]}
do
echo $p $p >> ${tmpfolder}/phenosself
done




# within-sex (cross-trait)
cat ${tmpfolder}/phenoscomb | grep -v -f ${female_ids} >  ${tmpfolder}/m_phenoscomb
cat ${tmpfolder}/phenoscomb | grep -v -f ${male_ids} >  ${tmpfolder}/f_phenoscomb



cat ${tmpfolder}/m_phenoscomb > ${tmpfolder}/phenoscomballmin
cat ${tmpfolder}/f_phenoscomb >> ${tmpfolder}/phenoscomballmin


# within-trait (f vs m)
rm -rf ${tmpfolder}/combipairs
for r in $(seq 1 $(cat ${pairs_ids} |  wc -l))
do
PAIR=$(cat ${pairs_ids} |  sed -n ${r}p)
CODE1=$(cat ${pairs_ids} |  sed -n ${r}p | cut -d ' ' -f1)
CODE2=$(cat ${pairs_ids} |  sed -n ${r}p | cut -d ' ' -f2)
echo ${munge_dir}/${CODE1}${suffix} ${munge_dir}/${CODE2}${suffix} >> ${tmpfolder}/combipairs
done



# self
cat ${tmpfolder}/phenosself >> ${tmpfolder}/phenoscomballmin


# pairs 
cat ${tmpfolder}/combipairs >> ${tmpfolder}/phenoscomballmin
