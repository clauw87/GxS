#!/bin/bash



module load BEDTools/2.29.2-GCC-9.3.0


# Input BED files
#FILE_A="2-compare-m-f/real/outputs/ADr1um:bm5m:ADr1uf:bm5f/gw_pleios_m.txt"
#FILE_B="2-compare-m-f/real/outputs/ADr1um:bm5m:ADr1uf:bm5f/gw_pleios_f.txt"

FILE_A=3-clump-pleios/real/outputs/ADr1uf:bm5f.gz/ADr1uf:bm5f.gz.0.00000005.result.clump.loci.csv
FILE_B=3-clump-pleios/real/outputs/ADr1um:bm5m.gz/ADr1um:bm5m.gz.0.00000005.result.clump.loci.csv

# Temporary sorted files names
SORTED_A="sorted_A.bed"
SORTED_B="sorted_B.bed"

# Output
OUTPUT="overlapping_regions.bed"



# MAIN ------------

# Step 1: Sort BED files
echo "Sorting input files..."
# chrN START END 

cat $FILE_A | tail -n+2 | cut -f2,5,6 | sort -k1,1 -k2,2n  > $SORTED_A
cat $FILE_B | tail -n+2 | cut -f2,5,6 |  sort -k1,1 -k2,2n $FILE_B > $SORTED_B


# Step 2: Find overlaps and closeby regions using bedtools
echo "Finding overlaps with bedtools..."
bedtools window -a "$SORTED_A" -b "$SORTED_B" -w 250000 -wa -wb > "$OUTPUT"



# Step 3: Done
echo "Overlaps saved to $OUTPUT"

