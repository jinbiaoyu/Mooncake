
set -x
export MC_GID_INDEX=n
./transfer_engine_bench --mode=target \
                        --metadata_server=10.121.4.11:2379 \
                        --local_server_name=10.121.4.11:12345 \
                        --device_name=mlx5_0
                        # --device_name=erdma_0