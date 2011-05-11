#!/bin/bash
ramfs_size_mb=1024
mount_point=/Users/zog/ramfs

ramfs_size_sectors=$((${ramfs_size_mb}*1024*1024/512))
ramdisk_dev=`hdid -nomount ram://${ramfs_size_sectors}`
newfs_hfs -v 'Volatile HD' ${ramdisk_dev}
mkdir -p ${mount_point}
mount -o noatime -t hfs ${ramdisk_dev} ${mount_point}
chown zog:staff ${mount_point}
chmod 1777 ${mount_point}
mkdir -p ${mount_point}/postgresql
chown postgres:postgres ${mount_point}/postgresql

#CREATE TABLESPACE ram LOCATION '/Users/zog/ramfs/postgresql';
