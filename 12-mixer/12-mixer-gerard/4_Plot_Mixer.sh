#!/bin/bash

# Define variables
pwd="/gpfs42/projects/lab_anavarro/disease_pleiotropies/gxs/12-mixer-gerard/"
gwasFolder="$pwd/good"
output="$pwd/outputs_mixer"
trait1="a9f.gz"
name1="a9f"
plotFolder="$output/plots"
mixerFolder="/homes/users/gmuntane/scratch/Software/mixer/precimed"

mkdir -p $plotFolder

# Loop through the list of disease IDs
#counter=0
ls $gwasFolder/*.gz | while read line; do
  trait2=$(basename $line)
  name2=$(basename $line | cut -f1 -d"_")
  
  
  # Define Slurm job name
  job_name="plot_$name2"
  
#  counter=$((counter+1))
#    if [ $counter -eq 27 ]; then
#      break
#    elif [ $counter -lt 18 ]; then
    # Additional condition to break if counter is less than 19
#      continue

#    else
  # Print the current disease ID
    
  echo "Processing disease ID: $name2"
  # Submit a Slurm job to process and plot GWAS data
  sbatch --job-name="$job_name" "$pwd/array_plot.sbatch" "$pwd" "$gwasFolder" "$name1" "$name2" "$output" "$plotFolder" "$mixerFolder"
  #sh "$pwd/array_plot.sbatch" "$pwd" "$gwasFolder" "$name1" "$name2" "$output" "$plotFolder" "$mixerFolder"
#  fi
  # Optionally, use 'break' if you only want to process the first disease for testing purposes
  
done

