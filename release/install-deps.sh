#!/bin/bash
set -ex
dpkg --add-architecture arm64

# Remove ALL apt source configs — both legacy .list and modern DEB822 .sources format
find /etc/apt/sources.list.d -name '*.list' -delete
find /etc/apt/sources.list.d -name '*.sources' -delete
# Remove GitHub Actions mirrorlist — doesn't support per-arch constraints
rm -f /etc/apt/apt-mirrors.txt

. /etc/lsb-release
cat <<EOT >/etc/apt/sources.list
# amd64 — standard archive + security
deb [arch=amd64] http://us.archive.ubuntu.com/ubuntu ${DISTRIB_CODENAME} main restricted universe multiverse
deb [arch=amd64] http://us.archive.ubuntu.com/ubuntu ${DISTRIB_CODENAME}-updates main restricted universe multiverse
deb [arch=amd64] http://us.archive.ubuntu.com/ubuntu ${DISTRIB_CODENAME}-backports main restricted universe multiverse
deb [arch=amd64] http://security.ubuntu.com/ubuntu ${DISTRIB_CODENAME}-security main restricted universe multiverse
# arm64 — ports only (security.ubuntu.com does not host arm64)
deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports ${DISTRIB_CODENAME} main restricted universe multiverse
deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports ${DISTRIB_CODENAME}-updates main restricted universe multiverse
deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports ${DISTRIB_CODENAME}-backports main restricted universe multiverse
deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports ${DISTRIB_CODENAME}-security main restricted universe multiverse
EOT

apt-get update
apt-get install -fy \
  build-essential \
  libsystemd-dev \
  gcc-aarch64-linux-gnu \
  libc6-dev-arm64-cross \
  libsystemd-dev:arm64
