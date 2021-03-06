#!/bin/bash -x

pip install -r requirements.txt

DATA_DIR="../data/"
if [ ! -d ${DATA_DIR} ]; then
  mkdir ${DATA_DIR}
fi

wget -nc https://jaqket.s3-ap-northeast-1.amazonaws.com/data/train_questions.json -P ${DATA_DIR}
wget -nc https://jaqket.s3-ap-northeast-1.amazonaws.com/data/dev1_questions.json -P ${DATA_DIR}
wget -nc https://jaqket.s3-ap-northeast-1.amazonaws.com/data/dev2_questions.json -P ${DATA_DIR}
wget -nc https://jaqket.s3-ap-northeast-1.amazonaws.com/data/candidate_entities.json.gz -P ${DATA_DIR}

wget -nc https://www.nlp.ecei.tohoku.ac.jp/projects/AIP-LB/static/aio_leaderboard.json -P ${DATA_DIR}

# name of working dir
echo 'name of working dir'
read NAME

WORK_DIR="../${NAME}/"
if [ ! -d ${WORK_DIR} ]; then
  mkdir -p ${WORK_DIR}/sh
  cp ../JAQKET_baseline/run_jaqket_baseline_sample.sh ${WORK_DIR}
  cp ../JAQKET_baseline/run.sh ${WORK_DIR}
  cp -r ../JAQKET_baseline/sh/ ${WORK_DIR}/
fi

echo "next ..."
echo "$ cd ${WORK_DIR} && ./run_jaqket_baseline_sample.sh"
