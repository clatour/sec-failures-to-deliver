#!/bin/bash

wget --mirror -l1 --accept "cnsfails*.zip" https://www.sec.gov/data/foiadocsfailsdatahtm
mkdir -p archives 
find www.sec.gov -iname '*.zip' -exec cp '{}' archives \; 
pushd archives && unzip '*.zip'

sed -e '/^Trailer/d' -e '/^\r$/d' -e '/PRICE$/d' *.txt \
  | sort \
  | uniq \
  | awk '{a[NR-1]=$0}END{for(i=0;i<NR;++i)print(a[(i-1+NR)%NR])}' > pre.psv

xsv fmt -d '|' pre.psv -o ../ftds.csv
popd
