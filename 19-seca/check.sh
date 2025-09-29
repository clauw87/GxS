# 19 done only in version P clumping 1
la real/outputs/*/*.SECA_results.txt | wc -l

cat real/outputs/*.err | grep Error | grep -v variants

