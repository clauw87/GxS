#!/bin/bash
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J pat
#SBATCH --mem 120G # memory pool for all cores
#SBATCH -t 0-05:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address

 




#ENV=$1
#GEN=$2
#POP=$3
#FILE=$4


# NO o-o-m module load Python/3.6.6-foss-2018b

#module load Python/3.7.4-GCCcore-8.3.0

# NO sklearn module load Python/3.10.4-GCCcore-11.3.0

# NO sklearn module load Python/3.8.6-foss-2020b-cnvkit

module load Python/3.8.2-GCCcore-9.3.0

#python ./test/scripts/pat/main.py -e $ENV -g $GEN -n $POP -f $FILE


python ./test/scripts/pat/main.py -e ./1160_f_1200_f.env -g ./1160_f_1200_f.gen -n ./1160_f_1200_f.pop -f ./1160_f_1200_f.file -o ./test/outputs/results.txt


