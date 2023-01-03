#!/bin/bash
# 

function create_partition () {

(
echo n # Add a new partition
echo P # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo t  # Changing type
echo fd # for selecting Linux Raid 
echo w # Write changes
) | sudo fdisk $1

}

function examin_disk () {
sleep 1
mdadm -E /dev/vd[c-e]
mdadm -E /dev/vd[c-e]1
}

echo "Installing mdadm............." 
sleep 1
yum install mdadm -y
echo 

read -p "How many disks to partition: " disk_no
read -p "Enter the disk names (e.g. sdb sdc sdd): " -a disk_names

echo "=======Creating Partition=========="
sleep 1

if [ -n "$disk_no" ]
then
 for i in ${disk_names[@]}
 do
  create_partition "/dev/$i"
 done
fi

echo "=======Disk Partition Completed=========="
lsblk
sleep 2
echo "=======Creating Raid 5=========="
echo "Raid 5 is going to be created by assuming the partitions are "sdb1 sdc1 and sdd1". If there are more disk partitions, then create Raid separately."
read -p "Continue with assumed partitions (y/n)? " Check
case $Check in
	y|Y )
        examin_disk
        sleep 1
        mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1
        echo 
        echo "check the status of Raid "cat /proc/mdstat""
	;;
	n|N )
	echo "cool... create Raid separately"
	exit
	;;
esac

