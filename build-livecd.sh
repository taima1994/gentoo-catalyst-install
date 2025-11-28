#!/bin/bash
set -e

echo "🎯 Building Gentoo LiveCD..."

# Tạo spec file cho LiveCD
cat > /var/tmp/catalyst/livecd-stage1.spec << 'EOF'
subarch: amd64
version_stamp: gentoo-livecd-$(date +%Y%m%d)
target: stage1
rel_type: default
profile: default/linux/amd64/17.1/openrc
snapshot: latest
source_subpath: gentoo
compression_mode: pixz
update_seed: yes
EOF

cat > /var/tmp/catalyst/livecd-stage2.spec << 'EOF'
subarch: amd64
version_stamp: gentoo-livecd-$(date +%Y%m%d)
target: stage2
rel_type: default
profile: default/linux/amd64/17.1/openrc
snapshot: latest
source_subpath: gentoo
compression_mode: pixz
update_seed: yes
EOF

cat > /var/tmp/catalyst/livecd-stage3.spec << 'EOF'
subarch: amd64
version_stamp: gentoo-livecd-$(date +%Y%m%d)
target: livecd-stage2
rel_type: livecd
profile: default/linux/amd64/17.1/openrc
snapshot: latest
source_subpath: gentoo
compression_mode: pixz
update_seed: yes
bootloader: grub
livecd/type: gnome
livecd/skipfs: yes
EOF

# Build stages
echo "🏗️ Building stage1..."
catalyst -f /var/tmp/catalyst/livecd-stage1.spec

echo "🏗️ Building stage2..."
catalyst -f /var/tmp/catalyst/livecd-stage2.spec

echo "🏗️ Building LiveCD..."
catalyst -f /var/tmp/catalyst/livecd-stage3.spec

echo "✅ LiveCD build complete!"
echo "📀 ISO location: /var/tmp/catalyst/builds/gentoo-livecd-*.iso"
