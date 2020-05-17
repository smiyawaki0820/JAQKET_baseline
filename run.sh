#!/bin/bash -x

echo 'train/test/both'
read MODE


cat << EOS > /tmp/work.txt
DDIR=../data/
OUTDIR=output_dir
TRAIN=train_questions.json
DEV=dev1_questions.json
TEST=dev2_questions.json
ENTITY=candidate_entities.json.gz

TRAIN_NUM_OPTIONS=4
PER_GPU_TRAIN_BATCH_SIZE=1
GRADIENT_ACCUMULATION_STEPS=8
NUM_TRAIN_EPOCHS=5
LOGGING_STEPS=10
SAVE_STEPS=1000

EVAL_NUM_OPTIONS=20
PER_GPU_EVAL_BATCH_SIZE=4
EOS


if [ ! -d output_dir ] ; then
  mkdir output_dir
fi


# copy config file to output_dir/configs.txt
cp /tmp/work.txt output_dir/configs.txt


if [ ${MODE} = 'train' ] || [ ${MODE} = 'both' ] ; then
  echo 'TRAIN'
  bash sh/train.sh
fi


if [ ${MODE} = 'test' ] || [ ${MODE} = 'both' ] ; then
  echo 'TEST'
  bash sh/test.sh
fi


echo 'DONE'

