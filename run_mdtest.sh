#!/bin/bash
mpirun -np 1 mdtest -z 0 -b 0 -I 10 -d /mnt/sdb/mdtest -C -F -L -w 1k -T -R -E -e 1k -r --posix.odirect --random-seed=42
sudo strace -ttT -fC -o mdtest_strace/strace_mdtest_1000_100k.log mdtest -z 0 -b 0 -I 1000 -d /mnt/sdb/mdtest -C -F -L -w 100k -T -R -E -e 100k -r --posix.odirect --random-seed=42

# mkdir("/mnt/sdb/mdtest/test-dir.0-0/mdtest_tree.0/"

# 一直循环，顺序创建
# openat(AT_FDCWD, "/mnt/sdb/mdtest
# lseek
# write
# close

# 一直循环，随机读取(随机数种子)
# newfstatat(AT_FDCWD, "/mnt/sdb/mdtest

# 一直循环，随机读取(随机数种子)
# openat(AT_FDCWD, "/mnt/sdb/mdtest
# lseek
# read
# close

# unlink("/mnt/sdb/mdtest/

# rmdir("/mnt/sdb/mdtest/test-dir.0-0/mdtest_tree.0/


# 清除元数据缓存 --> 写数据 --> 清除元数据缓存 --> 读元数据 --> 清除元数据缓存 --> 读数据 --> 删除数据
sudo ./rm_cache.sh
sudo strace -ttT -fC -o mdtest_strace/strace_mdtest_w.log mdtest -z 0 -b 0 -I 10 -d /mnt/sdb/mdtest -C -F -L -w 1k --posix.odirect --random-seed=42
sudo ./rm_cache.sh
sudo strace -ttT -fC -o mdtest_strace/strace_mdtest_r_metadata.log mdtest -z 0 -b 0 -I 10 -d /mnt/sdb/mdtest -F -L -T -R --posix.odirect --random-seed=42
sudo ./rm_cache.sh
sudo strace -ttT -fC -o mdtest_strace/strace_mdtest_r_data.log mdtest -z 0 -b 0 -I 10 -d /mnt/sdb/mdtest -F -L -E -e 1k -R -r --posix.odirect --random-seed=42
