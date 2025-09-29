#!/bin/bash
#


#FILE=./1160_f_1200_f.file
#GEN=./1160_f_1200_f.gen
#ENV=./1160_f_1200_f.env
#POP=./1160_f_1200_f.pop


#COMMAND="./test/scripts/pat/main.sh $ENV $GEN $POP $FILE"



COMMAND="./real/scripts/pat/main.sh"


sbatch $COMMAND


