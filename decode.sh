set -x

CUDA_VISIBLE_DEVICES=1 \
VLLM_LOGGING_LEVEL=DEBUG \
MOONCAKE_CONFIG_PATH=./mooncake.json \
VLLM_DISTRIBUTED_KV_ROLE=consumer \
VLLM_USE_MODELSCOPE=True \
python3 -m vllm.entrypoints.openai.api_server --model /mnt/nvme1/yujinbiao/Qwen2-7B-Instruct  --port 8200 --max-model-len 10000 --gpu-memory-utilization 0.8 \
--kv-transfer-config '{"kv_connector":"MooncakeConnector","kv_role":"kv_consumer","kv_rank":1,"kv_parallel_size":2,"kv_buffer_size":2e9}'