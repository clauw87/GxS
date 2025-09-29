# target
cat ../../14-placo/1-run-placo/real/tmp/combination.pairs.minuselenas | tr ' ' ':' > real/inputs/target.txt
TARGET=real/inputs/target.txt


# tmp

#TMP=real/tmp_280125
#OUTPUTS=./real/outputs_280125

TMP=real/tmp 
OUTPUTS=./real/outputs

ls ${TMP}/*.gz | xargs -I {} basename {} | cut -d '.' -f1 > tmps_



cat $TARGET | grep -v -f tmps_ > failed_tmp







# seg
ls ${OUTPUTS}/*.segbfs.gz | xargs -I {} basename {} | cut -d '.' -f1 > outs_


# unfinished
cat tmps_ | grep -v -w -f outs_ > sid_pairs_undone_.txt
