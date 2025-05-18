# ext4_no_dir_index
sudo umount /dev/sdb
sudo e2fsck -f -D /dev/sdb
sudo tune2fs -O ^dir_index /dev/sdb
sudo mount /dev/sdb /mnt/sdb
sudo tune2fs -l /dev/sdb

# ext4_dir_index
sudo umount /dev/sdb
sudo e2fsck -f -D /dev/sdb
sudo tune2fs -O dir_index /dev/sdb
sudo mount /dev/sdb /mnt/sdb
sudo tune2fs -l /dev/sdb

# xfs
sudo umount /dev/sdb
sudo mkfs.xfs -f /dev/sdb
sudo mount /dev/sdb /mnt/sdb
sudo chown -R llm:llm /mnt
xfs_info /dev/sdb

# btrfs
sudo umount /dev/sdb
sudo mkfs.btrfs -f /dev/sdb
sudo mount /dev/sdb /mnt/sdb
sudo chown -R llm:llm /mnt

# zfs
sudo umount /dev/sdb
sudo zpool create mypool /dev/sdb
