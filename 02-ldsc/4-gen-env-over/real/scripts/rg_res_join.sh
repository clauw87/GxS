#res=../3-rg/real/outputs/*.log
res=./real/tmp/*.in.txt

FILES=($(ls $res))
  for I in ${FILES[@]}; do
  PHEN=$(echo $I | sed 's/\.in.txt//')
  tail -n5 $I | head -n2 > $PHEN.rg
  if [[ $I == ${FILES[0]} ]]; then
  cat $PHEN.rg > ./real/tmp/rg_res
  else
    cat $PHEN.rg | sed '1d' >> ./real/tmp/rg_res
  fi
  done
