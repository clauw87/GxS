
RGLOGS=$1
IN_DIR=$2
TMP_DIR=$3
sex=$4


OUT=${TMP_DIR}/${sex}.rg_res

res=${RGLOGS}


FILES=($(cat $res))
  for I in ${FILES[@]}; do
  PHEN=$(basename $I | sed 's/\-genetic-correlation.log//')
  IN=${IN_DIR}/${sex}.${PHEN}.rg
  tail -n5 $I | head -n2 > ${IN}
  if [[ $I == ${FILES[0]} ]]; then
    cat ${IN} > ${OUT}
  else
    cat ${IN} | sed '1d' >> ${OUT}

  fi
  done

