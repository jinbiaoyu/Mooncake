#!/bin/bash

# Requirement: 2x GPUs.


# Model: meta-llama/Meta-Llama-3.1-8B-Instruct
# Query: 1024 input tokens, 6 output tokens, QPS 2/4/6/8, 100 requests
# Resource: 2x GPU
# Approaches:
# 2. Chunked prefill: 2 vllm instance with tp=4, equivalent to 1 tp=4 instance with QPS 4
# 3. Disaggregated prefill: 1 prefilling instance and 1 decoding instance
# Prefilling instance: max_output_token=1
# Decoding instance: force the input tokens be the same across requests to bypass prefilling

set -ex

kill_gpu_processes() {
  # kill all processes on GPU.
  pgrep pt_main_thread | xargs -r kill -9
  pgrep python3 | xargs -r kill -9
  for port in 8000 8100 8200; do lsof -t -i:$port | xargs -r kill -9; done
  sleep 1
}

wait_for_server() {
  # wait for vllm server to start
  # return 1 if vllm server crashes
  local port=$1
  timeout 1200 bash -c "
    until curl -s localhost:${port}/v1/completions > /dev/null; do
      sleep 1
    done" && return 0 || return 1
}

benchmark() {
  results_folder="./results"
  model="/data/yujinbiao/Qwen2.5-7B-Instruct"
  dataset_name="sonnet"
  dataset_path="../sonnet_4x.txt"
  num_prompts=100
  qps=$1
  prefix_len=50
  input_len=1024
  output_len=$2
  tag=$3

  python3 ../benchmark_serving.py \
          --backend vllm \
          --model $model \
          --dataset-name $dataset_name \
          --dataset-path $dataset_path \
          --sonnet-input-len $input_len \
          --sonnet-output-len "$output_len" \
          --sonnet-prefix-len $prefix_len \
          --num-prompts $num_prompts \
          --port 8000 \
          --save-result \
          --result-dir $results_folder \
          --result-filename "$tag"-qps-"$qps".json \
          --request-rate "$qps"

  sleep 2
}


main() {

  (which wget && which curl) || (apt-get update && apt-get install -y wget curl)
  (which jq) || (apt-get -y install jq)
  (which socat) || (apt-get -y install socat)
  (which lsof) || (apt-get -y install lsof)

  pip install quart httpx matplotlib aiohttp datasets

  # rm -rf results
  # mkdir results

  default_output_len=6

  export VLLM_HOST_IP=$(hostname -I | awk '{print $1}')

  # launch_chunked_prefill
  # for qps in 2 4 6 8; do
  # benchmark $qps $default_output_len chunked_prefill
  # done
  # kill_gpu_processes

  # launch_disagg_prefill
  for qps in 2 4 6 8; do
  # benchmark $qps $default_output_len disagg_prefill_tcp_tp1_in1024_out6
  # benchmark $qps $default_output_len disagg_prefill_rdma_tp1_in1024_out6
  # benchmark $qps $default_output_len disagg_prefill_rdma2x_tp1_in1024_out6
  # benchmark $qps $default_output_len no_disagg_tp1_in1024_out6
  benchmark $qps $default_output_len no_disagg_tp2_in1024_out6
  done
  kill_gpu_processes

  # python3 visualize_benchmark_results.py

}


main "$@"
