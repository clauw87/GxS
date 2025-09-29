#!/bin/bash

# set output directory
OUTPUTDIR=./output

# set common analysis input parameters
loc=../input/blocks_s2500_m25_f1_w200.locfile
info=../input/input.info.txt
sampleoverlap=../sample_overlap/sample.overlap.txt
refprefix=../input/g1000_eur/g1000_eur
univthres=


target=B2
phenos=(`cat $info | grep -v -w $target |  cut -f 1 | tail -n +2`)
#phenos=109


# if univthreshold is not provided it would be set as 0.05/n loci (Bonferroni adjusted)
# if target is not provided do all vs all


# get combinations of pairs of traits to analyse together in run
#phenos=(`cat $info | cut -f 1 | tail -n +2`)
#awk -f combinations.awk <<< ${phenos[@]} > ./phenoscomb
 
# if only some combinations  
#cat ../input/phenoscomb | grep A2 > a2
#cat ../input/phenoscomb | grep B1 > b1  
#cat ../input/phenoscomb | grep B2 > b2
#cat ../input/phenoscomb | grep C2 > c2
#cat a2 b1 b2 c2 | sort -u > ./subphenoscomb

#c=./subphenoscomb

#c=./phenoscomb 
#nrow=`cat $c | wc -l`


#for p in pair in rows take each column as a pheno as p1 and p2 to combinate them in the form p1;p2 for lava input

#for i in $(seq 1 1 $nrow)
#do
#r=(`sed -n "${i}p" < $c`)
#echo "doing pair ${r[@]}"


# concatenate phenotypes in the form p1;p2 
#phenos=`echo ${r[0]}";"${r[1]}`


for i in `seq 0 1 $(( ${#phenos[@]} - 1 ))`

do

echo "doing pair ${target}-${phenos[i]}"


traits=`echo ${target}";"${phenos[i]}`


# set output file name based on phenotype pairs 
outfname=`echo ${target}"."${phenos[i]}`



job_file="${outfname}.job"

echo "#!/bin/bash
#SBATCH --job-name=${outfname}.job
#SBATCH --output=${OUTPUTDIR}/${outfname}.out
#SBATCH --error=${OUTPUTDIR}/${outfname}.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=32GB


#load modules
#module load gcc/8.1.0
#module load pcre2/10.35
#module load R/4.0.3 

module load R/3.6.0-foss-2018b

echo "doing pair ${r[@]}"


# call R script
Rscript lava_param_targeted.R  $refprefix $loc $info $sampleoverlap '$traits' $OUTPUTDIR/$outfname $univthres" >  $job_file

sbatch $job_file

done
