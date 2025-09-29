# convincing discordant?
# 23 lines
cat ../1-run-clumped/real/outputs/coloc_* | grep -w SOMEDISCORDANT | grep -w CONVINCING | cut -f1 | sort -u | wc -l
cat ../1-run-clumped/real/outputs/coloc_* | grep -w DISCORDANT | grep -w CONVINCING | cut -f1 | sort -u | wc -l
# 21 different SNPs


# column 2 code eg 4370m:r5m # discordant -concordant comes from compare_m_f results in placo unclumped results
cat ../1-run-clumped/real/outputs/coloc_* | grep -w SOMEDISCORDANT | grep -w CONVINCING | cut -f2 | sort -u
cat ../1-run-clumped/real/outputs/coloc_* | grep -w DISCORDANT | grep -w CONVINCING | cut -f2 | sort -u


# pairs with convincing (shared causal snp) discordant loci in both sexes of a pair of traits
# EG 177f:a7f 


RES_FOLDER=../1-run-clumped/real/outputs
TMP_FOLDER=./real/tmp


COMMAND="./real/scripts/res_table.sh ${RES_FOLDER} ${TMP_FOLDER}"


sbatch ${COMMAND}
