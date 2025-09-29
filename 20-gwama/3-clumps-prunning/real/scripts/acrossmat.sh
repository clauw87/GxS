
#TRAITS=../3-clump/real/tmp/traits.list

TRAITS=$1
RES=$2
CLUMPDIR=$3
TYPED=$4


Rscript ./real/scripts/acrossmat.R ${TRAITS} ${RES} ${CLUMPDIR} ${TYPED}
