
from collections import OrderedDict 
import json
import os
import pandas as pd




def list_file(dir):
    import os
    return [x for x in os.listdir(dir) if not x.startswith('.')]

visual_keys = [
    "duration",
    "total_input_tokens",
    "total_output_tokens",
    "request_throughput",
    "output_throughput",
    "total_token_throughput",
    "mean_ttft_ms",
    "median_ttft_ms",
    "p99_ttft_ms",
    "mean_tpot_ms",
    "median_tpot_ms",
    "p99_tpot_ms",
    "mean_itl_ms",
    "median_itl_ms",
    "p99_itl_ms"
]
target_keys = [
    "Duration(s)",
    "Total Input Tokens",
    "Total Output Tokens",
    "Request Throughput(req/s)",
    "Output Throughput(tokens/s)",
    "Total Throughput(tokens/s)",
    "Mean ttft(ms)",
    "Median ttft(ms)",
    "P99 ttft(ms)",
    "Mean tpot(ms)",
    "Median tpot(ms)",
    "P99 tpot(ms)",
    "Mean itl(ms)",
    "Median itl(ms)",
    "P99 itl(ms)"
]
mapping_keys = dict(zip(visual_keys, target_keys))


if __name__ == '__main__':
    data_all = OrderedDict()

    results_dir = "./results"

    files = list_file(results_dir)

    # append set
    data_all["qps"] = []
    data_all["tp"] = []
    indexs = []
    for f in files:
        f_path = os.path.join(results_dir, f)
        print (f_path)
        with open(f_path) as fjson:
            res = json.load(fjson)
            file_name = f.split('.')[0]
            qps = file_name.split('-')[-1]
            tp = file_name.split('_')[-3]
            data_all["qps"].append(qps)
            data_all["tp"].append(tp)
            indexs.append(file_name)
            for data_key in visual_keys:
                data = res[data_key]
                data_key = mapping_keys[data_key]
                if data_key not in data_all:
                    data_all[data_key] = [data]
                else:
                    data_all[data_key].append(data)
    df = pd.DataFrame(data_all, index = indexs)
    df.to_csv(f"benmark_pref.csv")
