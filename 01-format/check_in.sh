
cat real/inputs/sumstats.list | xargs -I {} basename "{}" | sed s/.gz//g | sed s/.tsv//g | sed s/.hg19//g  > sumstats.ids

cat real/inputs/selected.ids | grep -v -w -f sumstats.ids
