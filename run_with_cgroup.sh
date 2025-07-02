#!/bin/bash

# 清除系统缓存并创建cgroup
sync; echo 3 > /proc/sys/vm/drop_caches
echo "rm_cache done"
sudo cgdelete -g memory:file_reader
sudo cgcreate -g memory:file_reader

# 限制内存
echo "+memory" > /sys/fs/cgroup/cgroup.subtree_control
cat /sys/fs/cgroup/file_reader/memory.max
echo 104857600 > /sys/fs/cgroup/file_reader/memory.max
cat /sys/fs/cgroup/file_reader/memory.max

# 运行脚本
cgexec -g memory:file_reader python3 read_load.py &

ps -ef | grep read_load

# 监控缓存命中率
PID=$(cat /sys/fs/cgroup/file_reader/cgroup.procs)

echo "监控进程 PID: $PID"

sudo perf stat -p $PID -e cache-misses,cache-references
