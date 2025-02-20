
set -x
export MC_GID_INDEX=n
./transfer_engine_bench --metadata_server=10.121.4.11:2379 \
                        --segment_id=10.121.4.11:12345 \
                        --local_server_name=10.121.4.13:12346 \
                        --device_name=erdma_1
