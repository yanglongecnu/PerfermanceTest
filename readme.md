# 项目描述
计算机性能测试与分析工具学习
# 计算机系统
## 硬件设备查看
```sh
sudo lshw -class system
sudo lshw -C cpu
sudo lshw -C memory
sudo lshw -C bus
sudo lshw -C Storage
sudo lshw -C network
sudo lshw -C video
```
# Linux存储栈性能测试、性能监控、特征采集与分析
## 用户态层面
### 内部日志
#### FIO
- 原理：负载生成+用户态端到端统计性能指标
- 构建负载：
    - fio -filename=/dev/sdb -direct=1 -iodepth=32 -rw=randread -ioengine=libaio -bs=4k -numjobs=1 -runtime=60 -group_reporting -name=test
- 监控指标
    - 带宽(min/max/avg/stdev bw)
    - IOPS(min/max/avg/stdev iops)
    - 延迟(min/max/avg/stdev slat/clat/lat)
    - 延迟分布(clat CDF,lat CDF)
    - cpu使用占比(usr/sys)
    - IO队列深度(submit/complete/total IO depths)
    - 磁盘状态(util)
#### dftracer
- 原理：利用代理和注解实现应用层多级特征采集

### 外部监控
#### htop
- 原理：借助procfs实现进程级别CPU/MeM/IO监控
- 先开启内核信息统计：sudo sysctl kernel.task_delayacct=1
- 开始监控：sudo htop
- 监控指标
    - 进程CPU/MEM统计信息(PRI NI VIRT RES SHR S CPU% MEM% TIME+)
    - 进程I/O统计信息(DISK R/W DISK READ DISK WRITE SWPD% IOD%)
#### strace
- 原理：借助ptrace和signal实现追踪进程系统调用
- 追踪命令：sudo strace -tttT -fC -o a_trace.log ./a.out
- 收集特征：记录程序调用的系统函数、参数、返回值及耗时
#### fatrace
- 原理：依赖 Linux 内核的 ​inotify 接口监听文件系统事件

## 内核态层面
### VFS
#### strace
- 原理：借助ptrace和signal实现追踪进程系统调用
- 追踪命令：sudo strace -tttT -fC -o a_trace.log ./a.out
- 收集特征：记录程序调用的系统函数、参数、返回值及耗时
#### vfs cache
- slabtop
/proc/sys/vm/slab_max

- dentry/inode缓存
    ```sh
    # 查看dentry+inode缓存
    sudo grep -E "dentry|ext4_inode_cache|xfs_inode" /proc/slabinfo
    sudo grep -E "dentry|inode" /proc/slabinfo
    # 清空dentry+inode缓存
    sync;echo 3 > /proc/sys/vm/drop_caches
    # 查看并修改dentry+inode缓存管理策略
    cat /proc/sys/vm/vfs_cache_pressure
    # 降低回收速度（值越小，内核越倾向于保留 dentry/inode 缓存）
    sudo sysctl -w vm.vfs_cache_pressure=50
    ```
### Page Cache
#### vmtouch
- 原理：基于mmap和mincore技术实现对文件page cache的管理(页缓冲比率、预加载、清除、锁定)
```sh
vmtouch -v 1.txt / vmtouch -v ./
vmtouch -tv 1.txt
vmtouch -ev 1.txt
vmtouch -lv 1.txt
```
#### bash脚本
```sh
# 缓存缺失率(read_bytes/rchar)
watch -n 1 ./get_pid_io.sh
# 缓存容量
通过cgroup和vm.min_free_kbytes间接影响进程可用page cache
# 清空缓存
sync; echo 1 > /proc/sys/vm/drop_caches
vmtouch -ve ./
```
### 物理文件系统
#### 文件系统调优
```sh
# ext4
sudo mke2fs /dev/sdb
sudo tune2fs -l /dev/sdb
sudo tune2fs -O ^dir_index /dev/sdb
sudo tune2fs -O dir_index /dev/sdb
sudo e2fsck -f -D /dev/sdb
# xfs
sudo xfs_info /mount/point
sudo xfs_admin -J size=128m /dev/sdb 
# 通用挂载参数
mount | grep /dev/sdb
mount -o noatime,dioread_nolock /dev/sdb /mnt/sdb
```
#### mdtest
- 文件系统元数据性能
```sh
mpirun -np 1 mdtest -z 0 -b 0 -I 10 -d /mnt/sdb/mdtest -C -F -L -w 1k -T -R -E -e 1k -r --posix.odirect --random-seed=42
# 脚本文件
./run_mdtest.sh 
```
#### fio
- 文件读写性能
```sh
fio -filename=/dev/sdb -direct=1 -iodepth=32 -rw=randread -ioengine=libaio -bs=4k -numjobs=1 -runtime=100 -group_reporting -name=test
fio --name=sync_randread200k --filename=/mnt/sdb/testfile --ioengine=sync --size=1G --bs=200k --rw=randread --iodepth=32 --direct=1 --numjobs=1 --time_based --runtime=30s --output fio_output/sync_randread200k -group_reporting 
# 脚本文件
./test_fio.sh
```
#### filefrag
- 文件碎片(文件逻辑地址->磁盘LBA)：filefrag -v 200kb_file 
#### fs_mark
- 文件系统极限性能、不同的同步策略性能、满盘稳定性
#### ior
- 并行文件系统基准性能
### 块设备层
#### 层次结构
Q2G(请求生成(remap、split)) --> G2I(请求合并与插入) --> I2D(请求调度和请求分派) --> D2C(请求下发与完成)
- 读写设备文件：
/dev/md0 /dev/nvme1n1 /dev/sda /dev/loop*
- Raid for MD
    - raid0 raid1 raid10 raid456内核模块
    - sudo mdadm --detail /dev/md0
- IO请求队列管理
    - 队列深度：cat /sys/block/sda/queue/nr_requests
    - 调度算法：cat /sys/block/sda/queue/scheduler
    - 调度器参数：find /sys/block/sda/queue/iosched -type f | xargs -I {} sh -c 'echo -n "{}:"; cat "{}"'
    - 队列数量：ll /sys/block/sda/mq/ ll   /sys/block/nvme0n1/mq/
    - 队列与CPU绑定关系：cat /sys/block/sda/mq/0/cpu_list  cat /sys/block/nvme0n1/mq/0/cpu_list
- 设备驱动(SATA/AHCI NVMe)
    ```sh
    udevadm info -q path /dev/sda
    sudo lspci -s 0000:00:17.0 -v 
    ```         
#### 监控工具
##### iostat
- 原理：借助procfs实现设备级别性能监控
- 运行负载和监控程序：sudo ./test_fio.sh & iostat -mx 1 -d /dev/sda
- 监控指标
    - 带宽(rkB/s wkB/s dMB/s)
    - IOPS(r/s w/s d/s f/s) 读、写、擦、刷
    - 平均I/O等待时间(r_await w_await d_await f_await)
    - 平均请求大小(rareq-sz wareq-sz dareq-sz)
    - 每秒合并请求数(rrqm/s wrqm/s drqm/s)
    - 合并请求比率(%rrqm %wrqm %drqm)
    - 平均队列深度(aqu-sz)
    - 设备利用率(%util)
##### blktrace
- 原理：借助内核tracepoint和debugfs实现块设备层各阶段追踪
- 生成日志：sudo ./test_fio.sh & sudo blktrace -d /dev/sdb -D blktrace
- 日志合并：sudo blkparse -i sdb -d sdb.trace.bin
- 日志统计：sudo btt -i sdb.trace.bin
- 监控指标
    - 各阶段(Q2Q Q2G G2I I2D D2C Q2C)统计信息(MIN AVG MAX N)
    - 各阶段(Q2G G2I Q2M I2D D2C)延迟比列
    - 请求合并信息(#Q #D Ratio)和块大小统计(BLKmin BLKavg BLKmax)
    - 实际平均请求队列深度(Avg Reqs@Q)
    - I/O激活时间信息(#Live Avg.Act Avg.!Act %Live)
##### biosnoop
- 原理：通过eBPF技术在内核层动态插入探针并通过内核哈希表将I/O请求与发起进程关联
### PCIe总线(PCIe Root Port,pcieport)
-  理论带宽
    -  SATA 3.0    6 Gbps    ~550 MB/s   机械硬盘、入门级 SSD
    -  PCIe 3.0x4  32 Gbps	~3.5 GB/s	高性能 NVMe SSD
    -  PCIe 4.0x4  64 Gbps	~7 GB/s     数据中心、AI 训练
-  PCIe设备网络拓扑：lspci -tv





# 内核参数查看与参数调优(/sys / sysfs)
- NVMe SSD设备(nvme/nvme-cli/原厂提供的工具)
- NVMe驱动
- 块设备层
- 逻辑卷管理层（LVM）
- 存储虚拟化层（RAID 所在层）
- 文件系统
- 页缓存

# 特征采集与性能监控(真实负载进程)


# 采用用户态驱动绕过内核(SPDK)
























# 网卡与网络性能测试指标
# 网卡理论带宽
# 网络吞吐量
# 小包转发性能
# 延迟与抖动
# 网络丢包率

# 网络测试工具
# iperf3
# DPDK

# 网络监控、诊断、与调优工具
# 网卡设备层
# ethtool(query or control network driver and hardware settings)
- 查看网卡基本信息：sudo ethtool eno1
- 查看网卡驱动：ethtool -i eno1
- 查看/修改网卡多队列(有的网卡不支持)：ethtool -l enp4s0f2np2 / ethtool -L eth0 combined 8
- 查看/修改网卡队列深度：ethtool -g eno1 / ethtool -G eno1 rx 4096 tx 4096
- 查看网卡流量统计信息：sudo ethtool -S eno1

# 内核层
# 内核参数
- 查看与修改： sysctl net.core.netdev_max_backlog / sudo sysctl -w net.core.netdev_max_backlog=4096
- 网卡驱动(Ring Buffer)：net.core.netdev_max_backlog
- 内核共享数据结构(sk_buff)：
- 软中断处理程序: net.core.dev_weight / net.core.netdev_budget / net.core.netdev_budget_usecs
- Backlog连接队列管理： net.core.somaxconn / net.ipv4.tcp_max_syn_backlog 
- Socket数据缓冲区：

# ss(another utility to investigate sockets)
# 应用层
# ifconfig
# tcpdump/Wireshark
# nmap
# iftop/nethogs
# 