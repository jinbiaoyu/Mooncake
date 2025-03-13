set -x
# CUDA_VISIBLE_DEVICES=0 \
# VLLM_LOGGING_LEVEL=DEBUG \
# VLLM_USE_MODELSCOPE=True \
# python3 -m vllm.entrypoints.openai.api_server --model /data/yujinbiao/Qwen2.5-7B-Instruct  \
# --port 8000 --max-model-len 10000 --gpu-memory-utilization 0.8

CUDA_VISIBLE_DEVICES=0,1 \
VLLM_LOGGING_LEVEL=DEBUG \
VLLM_USE_MODELSCOPE=True \
python3 -m vllm.entrypoints.openai.api_server --model /data/yujinbiao/Qwen2.5-7B-Instruct  \
--port 8000 --max-model-len 10000 --gpu-memory-utilization 0.8 --tensor-parallel-size 2
