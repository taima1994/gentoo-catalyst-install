#!/bin/bash
set -e

echo "🔥 Building Custom Gentoo ISO with Catalyst..."

# Tạo spec file cho custom ISO
cat > /var/tmp/catalyst/catalyst-iso.spec << 'EOF'
subarch: amd64
version_stamp: gentoo-catalyst-$(date +%Y%m%d)
target: catalyst
rel_type: catalyst
profile: default/linux/amd64/17.1/openrc
snapshot: latest
source_subpath: gentoo
compression_mode: pixz
update_seed: yes
catalyst/options: -a
catalyst/packages: "
    app-cdr/cdrtools
    dev-util/catalyst
    sys-boot/grub:2
    sys-fs/squashfs-tools
    net-misc/dhcpcd
    app-admin/sudo
    dev-vcs/git
"
EOF

# Build catalyst ISO
echo "🏗️ Building Catalyst ISO..."
catalyst -f /var/tmp/catalyst/catalyst-iso.spec

echo "✅ Catalyst ISO build complete!"
echo "📀 ISO location: /var/tmp/catalyst/builds/gentoo-catalyst-*.iso"
