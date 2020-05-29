#!/bin/bash -x

. /tmp/work.txt

python ./JAQKET_baseline/jaqket_baseline.py \
  --data_dir   ${DDIR} \
  --dev_fname  ${DEV}  \
  --test_fname ${TEST} \
  --task_name jaqket \
  --entities_fname ${ENTITY} \
  --model_name_or_path ${OUTDIR} \
  --eval_num_options ${EVAL_NUM_OPTIONS} \
  --per_gpu_eval_batch_size ${PER_GPU_EVAL_BATCH_SIZE} \
  --do_test \
  --do_eval

echo 'FIN TEST'

if [ ${TEST} = 'aio_leaderboard.json' ] ; then
  python scripts/create_submission_file.py \
    --test aio_leaderboard.json \
    --pred is_test_true_output_labels.txt \
    --fo submission.json \
    --wq -wc
fi
