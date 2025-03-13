set -x
curl http://localhost:8000/v1/completions     -H "Content-Type: application/json"     -d '{
        "model": "/data/yujinbiao/Qwen2.5-7B-Instruct",
        "prompt": "What is AI?",
        "max_tokens": 50,
        "temperature": 0
    }'
