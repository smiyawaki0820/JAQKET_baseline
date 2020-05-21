#!/usr/bin/bash

# rm
#rm -rf cand_*

# split dev file
#split -l 20 candidate_entities.json cand_

for f in cand_*
do
  #gzip ${f}
  mv ${f} ${f%.*}.json.gz
done

# ファイル下に収める
c=-1
for d in ./*.json.gz
do
 c=$((${c}+1))
 if [ $((${c}%3)) == 0 ] ; then
  mkdir cand_$((${c}/3))
  #echo ${c} ${d}
 fi
 mv ${d} cand_$((${c}/3))
done 
