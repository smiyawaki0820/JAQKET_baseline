#!/bin/bash -x

. /tmp/work.txt

python ../JAQKET_baseline/jaqket_baseline.py  \
  --data_dir   ${DDIR} \
  --model_name_or_path bert-base-japanese-whole-word-masking \
  --task_name jaqket \
  --entities_fname ${ENTITY} \
  --train_fname ${TRAIN} \
  --dev_fname   ${DEV} \
  --test_fname  ${TEST} \
  --output_dir ${OUTDIR} \
  --train_num_options ${TRAIN_NUM_OPTIONS} \
  --do_train \
  --do_eval \
  --do_test \
  --per_gpu_train_batch_size ${PER_GPU_TRAIN_BATCH_SIZE} \
  --gradient_accumulation_steps ${GRADIENT_ACCUMULATION_STEPS} \
  --num_train_epochs ${NUM_TRAIN_EPOCHS} \
  --logging_steps ${LOGGING_STEPS} \
  --save_steps ${SAVE_STEPS} \

#--init_global_step 1000 \
#--overwrite_output_dir

echo 'FIN TRAIN'
