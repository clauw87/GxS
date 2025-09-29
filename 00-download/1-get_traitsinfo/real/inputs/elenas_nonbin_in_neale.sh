cat neales_* | cut -f1,2 | grep  -f the_70.fixedname | cut -f1 | sort -u  | grep -v 20003_ |  grep -v 4728 | wc -l
