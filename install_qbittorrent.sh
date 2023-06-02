#!/bin/sh
set -x
ARCH="$(uname -m)"
echo "building for ${ARCH}"

QBT_VERSION=release-4.5.3_v2.0.9

if [ "${ARCH}" = "x86_64" ]; then
    qbit_arch="amd64"
elif echo "${ARCH}" | grep -E -q "armv6|armv7"; then
    qbit_arch="arm"
elif echo "${ARCH}" | grep -E -q "aarch64_be|aarch64|armv8b|armv8l|arm64"; then
    qbit_arch="arm64"
elif echo "${ARCH}" | grep -E -q "s390|s390x"; then
    qbit_arch="s390x"
fi

if [ -n "$qbit_arch" ]; then
	if [ -n "QBT_VERSION" ]; then
		wget -O /usr/bin/qbittorrent-nox "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/${ARCH}-qbittorrent-nox"
		chmod +x /usr/bin/qbittorrent-nox
	else
		wget -O /usr/bin/qbittorrent-nox "https://github.com/userdocs/qbittorrent-nox-static/releases/download/$QBT_VERSION/${ARCH}-qbittorrent-nox"
		chmod +x /usr/bin/qbittorrent-nox
	fi
else
    apk add --no-cache -X "http://dl-cdn.alpinelinux.org/alpine/edge/testing" qbittorrent-nox
fi
