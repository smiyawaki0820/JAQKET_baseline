#!user/bin/bash

# def array consisted of jsonl
# LS=`ls [dir of jsonls]`
echo -en "input dir of jsonl\n> " && read JSDIR
while [ ! -d ${JSDIR} ] ; do
  echo -en "again\n> " && read JSDIR
done
LS=`ls ${JSDIR}`

# dest of csv files (if existed then error)
echo -en "input dest dir\n> " && read DEST
while [ -d ${DEST} ] ; do
  echo -en "again\n> " && read DEST
done

SAVE_FILE=${DEST}/scores.csv
rm /tmp/qid.txt

count=0
for fjs in ${LS[@]} ; do
  fo=`echo ${fjs##*/}`
  fo=`echo ${fo%.*}`

  echo ${fo} >> /tmp/qid.txt

  fo=`echo ${DEST}/${fo}.csv`
  fjs=${JSDIR}/${fjs}

  python scripts/convert_jsonl_to_csv.py -fi ${fjs} -s ${DEST}

  LANG=C sort -u ${fo} -o ${fo}

  if [ ${count} == 0 ] ; then
    cp ${fo} ${SAVE_FILE}
  else
    join -e nan -a 1 -j 1 ${SAVE_FILE} ${fo} > /tmp/scores.csv
    mv /tmp/scores.csv ${SAVE_FILE}
  fi

  count=$((${count}+1))

done

header=`cat /tmp/qid.txt | tr "\n" " "`
sed -i "1s/^/- ${header}\n/" ${SAVE_FILE}
