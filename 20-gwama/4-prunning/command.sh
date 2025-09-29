#!/bin/bash




#rm -rf ./real/outputs/*


# "pooled_sbsnps"
# pool of all sb SNPs: 85640 SNPs
POOLED_FILE=../2-analyze/real/outputs/pooled.sbsnps.tab

# pooled_sbsnps_clumped
# pool of all sb clumped loci SNPs: 2213 lead SNPs 
POOLED_FILE=real/outputs/joined.clump

# proxy_loci
# clump result of all pool-clumping clumped loci SNPs # 1143 
POOLED_FILE=../3-clump/real/outputs/joined/result.clump.loci.csv

# proxy_indep
# clump indep of pool clumping clumo - indep SNPs (proxy in mat) # 1846
POOLED_FILE=../3-clump/real/outputs/joined/result.clump.indep.csv

TRAITS=../3-clump/real/tmp/traits.list


CODED="all"
TYPED="pooled_sbsnps"
OUTPUTS_DIR=./real/outputs



# 
COMMAND="./real/scripts/prune.sh ${POOLED_FILE} ${CODED} ${TYPED} ${OUTPUTS_DIR}"


sbatch ${COMMAND}
