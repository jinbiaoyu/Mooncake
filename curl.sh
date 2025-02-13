curl http://localhost:8000/v1/completions     -H "Content-Type: application/json"     -d '{
        "model": "/mnt/nvme1/yujinbiao/Qwen2-7B-Instruct",
        "prompt": "San Francisco is a",
        "max_tokens": 50,
        "temperature": 0
    }'