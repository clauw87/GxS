# Create table with RG values
# header
cat real/tmp/r9m:r9m | head -n1 > ./real/outputs/genetic-correlations.txt
# results line
cat real/tmp/* | grep -v -w gcov_int >> ./real/outputs/genetic-correlations.txt

#   cat ./real/outputs/genetic-correlations_oob.txt | wc -l  # 13689
#   cat ./real/outputs/genetic-correlations.txt | wc -l  #  13689
