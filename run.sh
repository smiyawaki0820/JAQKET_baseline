#!/bin/bash -x

echo 'train/test/both(train, test)/develop'
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

elif [ ${MODE} = 'test' ] || [ ${MODE} = 'both' ] ; then
  echo 'TEST'
  bash sh/test.sh

elif [ ${MODE} == 'develop' ] ; then
  
  GPU=`nvidia-smi -L | wc -l`
  if [ ${GPU} == 3 ] ; then 
    for DATA in ../data/entities/cand_*
    do
      ls ${DATA} > candidates.txt
      cat candidates.txt | awk -v foo=${DATA##*/} '{print foo "/" $1} > candidates.txt'
      cat candidates.txt | parallel -a - --jobs 85% --load 50% --memfree --noswap \
        'CUDA_VISIBLE_DEVICES=$(({%}%3)) python ../JAQKET_baseline/my_jaqket_baseline.py \
        --data_dir ../data/ \
        --pred_fname ../data/dev/dev_1/dev_aa.json \
        --entities_fname entities/{} \
        --task_name jaqket \
        --model_name_or_path output_dir \
        --eval_num_options 5 \
        --per_gpu_eval_batch_size 4 \
        --do_eval \
        --overwrite_cache'
    done
  fi

fi

echo 'DONE'

