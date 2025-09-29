#!/bin/sh
#
#SBATCH -p normal # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -J rg-join
#SBATCH --mem 60G # memory pool for all cores
#SBATCH -t 0-02:00 # time (D-HH:MM)
#SBATCH -o ./real/outputs/log.%j.out # STDOUT
#SBATCH -e ./real/outputs/log.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=claudia.vasallo@upf.edu # send-to address










res=../3-rg/real/outputs/*.log

#res=./real/tmp/*.in.txt

FILES=($(ls $res))
  for I in ${FILES[@]}; do
  PHEN=$(echo $I | sed 's/\.in.txt//')
  tail -n5 $I | head -n2 > $PHEN.rg
  if [[ $I == ${FILES[0]} ]]; then
  cat $PHEN.rg > ./real/tmp/rg_res
  else
    cat $PHEN.rg | sed '1d' >> ./real/tmp/rg_res
  fi
  done
