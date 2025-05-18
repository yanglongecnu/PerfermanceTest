#!/bin/bash
# 队列
    # 队列提交策略：阈值提交、超时提交、flush主动提交
    # 队列深度：iodepth
    # 队列提交/完成批次大小：iodepth_batch_submit、iodepth_batch_complete
    # 每个线程单独分配IO队列(libaio/io_uring)、无IO队列(sync/psync)
    # nr_requests是单队列，汇聚虽有IO线程的IO请求
# 测试1：iodepth=32（小于nr_requests）
fio -filename=/dev/sdb -direct=1 -iodepth=32 -rw=randread -ioengine=libaio -bs=4k -numjobs=1 -runtime=60 -group_reporting -name=test
# 测试2：iodepth=256（大于nr_requests）
fio -filename=/dev/sdb -direct=1 -iodepth=256 -rw=randread -ioengine=libaio -bs=4k -numjobs=32 -runtime=100 -group_reporting -name=test


# sync
sudo strace -ttT -fC -o fio_strace/strace_sync_randread200k.log fio --name=sync_randread200k --filename=/mnt/sdb/testfile --ioengine=sync --size=1G --bs=200k --rw=randread --iodepth=32 --direct=1 --numjobs=1 --time_based --runtime=30s --output fio_output/sync_randread200k -group_reporting 

# psync
sudo strace -ttT -fC -o fio_strace/strace_psync_randread200k.log fio --name=psync_randread200k --filename=/mnt/sdb/testfile --ioengine=psync --size=1G --bs=200k --rw=randread --iodepth=32 --direct=1 --numjobs=1 --time_based --runtime=30s --output fio_output/psync_randread200k -group_reporting 

# libaio
sudo strace -ttT -fC -o fio_strace/strace_libaio_randread200k.log fio --name=libaio_randread200k --filename=/mnt/sdb/testfile --ioengine=libaio --size=1G --bs=200k --rw=randread --iodepth=32 --direct=1 --numjobs=1 --time_based --runtime=30s --output fio_output/libaio_randread200k -group_reporting 

# io_uring
sudo strace -ttT -fC -o fio_strace/strace_io_uring_randread200k.log fio --name=io_uring_randread200k --filename=/mnt/sdb/testfile --ioengine=io_uring --size=1G --bs=200k --rw=randread --iodepth=32 --direct=1 --numjobs=1 --time_based --runtime=30s --output fio_output/io_uring_randread200k -group_reporting 
