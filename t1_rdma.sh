
set -x
export MC_GID_INDEX=n
./transfer_engine_bench --metadata_server=10.119.59.167:2379 \
                        --segment_id=10.119.59.167:12345 \
                        --local_server_name=10.119.59.93:12346 \
                        --device_name=mlx5_0
                        # --device_name=erdma_1
