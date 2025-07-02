#!/bin/bash

# 监控cgroup内存统计信息
for i in {1..200}
do
cat "***************************************************"
cat /sys/fs/cgroup/file_reader/memory.current
cat /sys/fs/cgroup/file_reader/memory.stat | grep file
cat /sys/fs/cgroup/file_reader/memory.stat | grep anon
cat /sys/fs/cgroup/file_reader/memory.stat | grep slab
cat /sys/fs/cgroup/file_reader/memory.stat | grep pgscan
cat /sys/fs/cgroup/file_reader/memory.stat | grep pgsteal
cat /sys/fs/cgroup/file_reader/memory.stat | grep pgfault
# cat /sys/fs/cgroup/file_reader/memory.stat
cat "***************************************************" 
sleep 1
done