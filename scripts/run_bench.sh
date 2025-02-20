set -x


python3 ut/benchmark_serving.py --backend vllm \
--model Qwen/Qwen2.5-7B-Instruct-GPTQ-Int4 \
--dataset-name sonnet --dataset-path ../sonnet_4x.txt \
--sonnet-input-len 1024 --sonnet-output-len 6 --sonnet-prefix-len 50 \
--num-prompts 200 \
--port 8000 \
--save-result \
--result-dir ./results \
--result-filename disagg_prefill-qps-2.json \
--request-rate 2

