#!/bin/bash

#Define variables
pwd="/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/12-mixer-gerard"
gwasFolder="$pwd/good"
output="$pwd/outputs_mixer"
trait1="a9f.gz"
name1="a9f"

## Run the secondary traits
ls $gwasFolder/*.gz | while read line; do
  echo $line
  trait2=$(basename $line)
  name2=$(basename $line | cut -f1 -d"_")
  echo $name2
  if [ "$trait2" != "$trait1" ]; then 
  tempXtrait="${output}/$name2"
  mkdir -p $tempXtrait

  sbatch Array_secondary_traits.sbatch $trait1 $trait2 $tempXtrait $name2 $name1

#  break
fi
done
