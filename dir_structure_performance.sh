#!/bin/bash
# 单级目录多文件写入性能
total_files=1000000
file_size=100k
dir=/mnt/sdb/mdtest
dir_deep=0
dir_width=0
thread=1
files=$total_files
ext_name=${total_files}_${dir_deep}_${dir_width}_${file_size}_${thread}
mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -C -F -L -w $file_size -T -R -E -e $file_size -r --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/w_rank_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/w_result_${ext_name} > mdtest_output/w_output_${ext_name}.txt

#二级目录多文件写入性能
arr=(10 20 40 50 80 100 200 400 500 800 1000)
for value in "${arr[@]}"
do
total_files=1000000
file_size=100k
dir=/mnt/sdb/mdtest
dir_deep=1
dir_width=$value
thread=1
files=$(($total_files/$dir_deep/$dir_width))
ext_name=${total_files}_${dir_deep}_${dir_width}_${file_size}_${thread}
mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -C -F -L -w $file_size -T -R -E -e $file_size -r --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/w_rank_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/w_result_${ext_name} > mdtest_output/w_output_${ext_name}.txt
done

#三级目录多文件写入
total_files=1000000
file_size=100k
dir=/mnt/sdb/mdtest
dir_deep=2
dir_width=10
thread=1
files=$(($total_files/$dir_width/$dir_width))
ext_name=${total_files}_${dir_deep}_${dir_width}_${file_size}_${thread}
mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -C -F -L -w $file_size -T -R -E -e $file_size -r --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/w_rank_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/w_result_${ext_name} > mdtest_output/w_output_${ext_name}.txt
