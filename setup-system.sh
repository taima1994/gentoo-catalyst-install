#!/bin/bash
echo "⚙️ Cấu hình hệ thống sau cài đặt..."

# Cấu hình network
echo "🌐 Cấu hình network..."
rc-update add dhcpcd default
rc-update add sshd default

# Cấu hình sudo
echo "🔐 Cấu hình sudo..."
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Tạo thư mục làm việc
echo "📁 Tạo thư mục làm việc..."
mkdir -p /home/gentoo/{builds,scripts,iso}
chown -R gentoo:gentoo /home/gentoo

# Cấu hình bashrc
echo "🐚 Cấu hình bashrc..."
cat >> /home/gentoo/.bashrc << 'EOF'
export PATH="$PATH:/home/gentoo/scripts"
alias ll='ls -la'
alias catalyst-build='cd /var/tmp/catalyst'
EOF

chown gentoo:gentoo /home/gentoo/.bashrc

echo "✅ System setup complete!"
