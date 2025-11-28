#!/bin/bash
set -e

echo "🔧 Thiết lập phân vùng ổ đĩa..."

# Xóa phân vùng cũ
for disk in /dev/sda /dev/sdb; do
    echo "🗑️  Xóa phân vùng $disk"
    sudo wipefs -a $disk
    sudo parted -s $disk mklabel gpt
done

# Phân vùng sda (HDD 931.5G)
echo "📁 Phân vùng HDD (sda)"
sudo parted -s /dev/sda mkpart primary 1MiB 513MiB
sudo parted -s /dev/sda set 1 esp on
sudo parted -s /dev/sda mkpart primary 513MiB 100%

# Phân vùng sdb (SSD 223.6G)
echo "📁 Phân vùng SSD (sdb)" 
sudo parted -s /dev/sdb mkpart primary 1MiB 513MiB
sudo parted -s /dev/sdb set 1 esp on
sudo parted -s /dev/sdb mkpart primary 513MiB 100%

# Format
echo "💾 Định dạng phân vùng..."
sudo mkfs.fat -F32 /dev/sda1
sudo mkfs.fat -F32 /dev/sdb1
sudo mkfs.ext4 /dev/sda2
sudo mkfs.ext4 /dev/sdb2

echo "✅ Phân vùng hoàn tất!"
