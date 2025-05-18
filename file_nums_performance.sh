#!/bin/bash


# 随着目录下文件数量的增加，写入性能和读取性能都会下降，呈现线性下降，由于线性元数据检索开销大
# ext4_no_dir_index
# rm -rf /mnt/sdb/mdtest
# arr=(1000 10000 100000 200000 300000 400000 500000 600000 700000 800000 900000 1000000)
# for value in "${arr[@]}"
# do
# total_files=$value
# file_size=100k
# dir=/mnt/sdb/mdtest
# dir_deep=0
# dir_width=0
# thread=1
# files=$total_files
# ext_name=file_nums_ext4_no_dir_index_${total_files}_${dir_deep}_${dir_width}_${file_size}_${thread}
# sudo ./rm_cache.sh
# echo "start write $value"
# mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -C -F -L -w $file_size --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_w_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_w_${ext_name} > mdtest_output/output_w_${ext_name}.txt
# echo "end write $value"
# sudo ./rm_cache.sh
# echo "start read metadata $value"
# mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -F -L -T -R --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_r_meta_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_r_meta_${ext_name} > mdtest_output/output_r_meta_${ext_name}.txt
# echo "end read metadata $value"
# sudo ./rm_cache.sh
# echo "start read and remove $value"
# mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -F -L -E -e $file_size -R -r --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_r_data_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_r_data_${ext_name} > mdtest_output/output_r_data_${ext_name}.txt
# echo "end read and remove $value"
# echo "done $value"
# done

# 随着目录下文件数量的增加，写入性能和读取性能都会下降，但是下降幅度不大，而且不呈现线性增长，因为启用目录hash索引
# ext4_dir_index
# rm -rf /mnt/sdb/mdtest
# arr=(1000 10000 100000 200000 300000 400000 500000 600000 700000 800000 900000 1000000)
# for value in "${arr[@]}"
# do
# total_files=$value
# file_size=100k
# dir=/mnt/sdb/mdtest
# dir_deep=0
# dir_width=0
# thread=1
# files=$total_files
# ext_name=file_nums_ext4_dir_index_${total_files}_${dir_deep}_${dir_width}_${file_size}_${thread}
# sudo ./rm_cache.sh
# echo "start write $value"
# mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -C -F -L -w $file_size --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_w_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_w_${ext_name} > mdtest_output/output_w_${ext_name}.txt
# echo "end write $value"
# sudo ./rm_cache.sh
# echo "start read metadata $value"
# mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -F -L -T -R --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_r_meta_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_r_meta_${ext_name} > mdtest_output/output_r_meta_${ext_name}.txt
# echo "end read metadata $value"
# sudo ./rm_cache.sh
# echo "start read and remove $value"
# mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -F -L -E -e $file_size -R -r --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_r_data_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_r_data_${ext_name} > mdtest_output/output_r_data_${ext_name}.txt
# echo "end read and remove $value"
# echo "done $value"
# done

# 随着目录下文件数量的增加，写入性能和读取性能都会下降，下降幅度较小，性能趋于稳定
# xfs
# rm -rf /mnt/sdb/mdtest
# arr=(1000 10000 100000 200000 300000 400000 500000 600000 700000 800000 900000 1000000)
# for value in "${arr[@]}"
# do
# total_files=$value
# file_size=100k
# dir=/mnt/sdb/mdtest
# dir_deep=0
# dir_width=0
# thread=1
# files=$total_files
# ext_name=file_nums_xfs_${total_files}_${dir_deep}_${dir_width}_${file_size}_${thread}
# sudo ./rm_cache.sh
# echo "start write $value"
# mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -C -F -L -w $file_size --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_w_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_w_${ext_name} > mdtest_output/output_w_${ext_name}.txt
# echo "end write $value"
# sudo ./rm_cache.sh
# echo "start read metadata $value"
# mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -F -L -T -R --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_r_meta_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_r_meta_${ext_name} > mdtest_output/output_r_meta_${ext_name}.txt
# echo "end read metadata $value"
# sudo ./rm_cache.sh
# echo "start read and remove $value"
# mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -F -L -E -e $file_size -R -r --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_r_data_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_r_data_${ext_name} > mdtest_output/output_r_data_${ext_name}.txt
# echo "end read and remove $value"
# echo "done $value"
# done

# 随着目录下文件数量的增加，写入性能和读取性能都会下降，
# btrfs
rm -rf /mnt/sdb/mdtest
arr=(1000 10000 100000 200000 300000 400000 500000 600000 700000 800000 900000 1000000)
for value in "${arr[@]}"
do
total_files=$value
file_size=100k
dir=/mnt/sdb/mdtest
dir_deep=0
dir_width=0
thread=1
files=$total_files
ext_name=file_nums_btrfs_${total_files}_${dir_deep}_${dir_width}_${file_size}_${thread}
sudo ./rm_cache.sh
echo "start write $value"
mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -C -F -L -w $file_size --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_w_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_w_${ext_name} > mdtest_output/output_w_${ext_name}.txt
echo "end write $value"
sudo ./rm_cache.sh
echo "start read metadata $value"
mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -F -L -T -R --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_r_meta_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_r_meta_${ext_name} > mdtest_output/output_r_meta_${ext_name}.txt
echo "end read metadata $value"
sudo ./rm_cache.sh
echo "start read and remove $value"
mpirun -np $thread mdtest -z $dir_deep -b $dir_width -I $files -d $dir -F -L -E -e $file_size -R -r --posix.odirect --random-seed=42 --saveRankPerformanceDetails=mdtest_output/detail/rank_r_data_${ext_name}.csv --savePerOpDataCSV=mdtest_output/detail/result_r_data_${ext_name} > mdtest_output/output_r_data_${ext_name}.txt
echo "end read and remove $value"
echo "done $value"
done