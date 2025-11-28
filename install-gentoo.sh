#!/bin/bash
set -e

echo "🚀 Bắt đầu cài đặt Gentoo..."

# Mount partitions
mkdir -p /mnt/gentoo
mount /dev/sdb2 /mnt/gentoo
mkdir -p /mnt/gentoo/{boot,home,var/tmp/catalyst}
mount /dev/sdb1 /mnt/gentoo/boot
mount /dev/sda2 /mnt/gentoo/home
mount /dev/sda1 /mnt/gentoo/var/tmp/catalyst

# Download stage3
cd /mnt/gentoo
echo "📥 Download stage3..."
STAGE3_URL="https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-openrc/stage3-amd64-openrc-20251123T153051Z.tar.xz"
wget -q --show-progress "$STAGE3_URL"
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

# Chuẩn bị chroot
cp -L /etc/resolv.conf etc/
mount -t proc /proc proc
mount --rbind /sys sys
mount --rbind /dev dev

# Script chroot
cat > setup-chroot.sh << 'EOF'
#!/bin/bash
set -e

echo "🔧 Cấu hình trong chroot..."

# Cấu hình cơ bản
echo "America/New_York" > /etc/timezone
emerge --config sys-libs/timezone-data --quiet
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
eselect locale set en_US.utf8
env-update && source /etc/profile

# Portage
emerge-webrsync --quiet

# Kernel và bootloader
emerge -q sys-kernel/gentoo-kernel-bin sys-kernel/linux-firmware
emerge -q sys-boot/grub:2
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

# Packages cơ bản
emerge -q app-arch/zstd sys-fs/btrfs-progs net-misc/dhcpcd app-admin/sudo dev-vcs/git

# Catalyst
emerge -q dev-util/catalyst app-cdr/cdrtools sys-fs/squashfs-tools

# User
echo "root:123456" | chpasswd
useradd -m -G users,wheel,portage -s /bin/bash gentoo
echo "gentoo:123456" | chpasswd
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Network
rc-update add dhcpcd default

# Catalyst directories
mkdir -p /var/tmp/catalyst/{builds,snapshots,packages}
chown -R gentoo:gentoo /var/tmp/catalyst

echo "🎉 Cài đặt hoàn tất!"
EOF

chmod +x setup-chroot.sh
chroot /mnt/gentoo /bin/bash /setup-chroot.sh

# Cleanup
umount -R /mnt/gentoo
echo "✨ Gentoo installed successfully!"
