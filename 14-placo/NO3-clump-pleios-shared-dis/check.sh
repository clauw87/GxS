cat real/inputs/clump.list | cut -d '/' -f4 | cut -d '.' -f1 > target

ls -lart real/outputs/*/*.0.00000005.result.clump.loci.csv
