# Plot file
# /joined.clump generated in 2 by joining all clumps from per pair-sex clumping



JOINFILE=./real/outputs/joined.clump



COMMAND="real/scripts/grouped_manhattan-joined.sh ${JOINFILE}"

sbatch ${COMMAND}


