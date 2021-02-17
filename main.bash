#!/bin/bash

wget --mirror -l1 --accept 'cnsfails*.zip' https://www.sec.gov/data/foiadocsfailsdatahtm
mkdir -p archive 
find www.sec.gov -iname '*.zip' -exec cp '{}' archive \; 
pushd archive && unzip -n '*.zip'

sed -e '/^Trailer/d' -e '/^\r$/d' -e '/PRICE$/d' -e '/\x0/d' *.txt \
  | sort \
  | uniq \
  | awk '{a[NR-1]=$0}END{for(i=0;i<NR;++i)print(a[(i-1+NR)%NR])}' > ../pre.psv

popd
mkdir -p out
xsv fmt -d '|' pre.psv -o out/ftds.csv
