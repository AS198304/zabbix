#!/bin/bash

set -e

ARCH=$(uname -m)
OS_VERSION=$(lsb_release -cs)

if [[ "$ARCH" == "x86_64" ]]; then
    if [[ "$OS_VERSION" == "bullseye" ]]; then
        wget https://repo.zabbix.com/zabbix/6.5/debian/pool/main/z/zabbix-release/zabbix-release_6.5-1+debian12_all.deb
        dpkg -i zabbix-release_6.5-1+debian12_all.deb
    elif [[ "$OS_VERSION" == "buster" ]]; then
        wget https://repo.zabbix.com/zabbix/6.5/debian/pool/main/z/zabbix-release/zabbix-release_6.5-1+debian11_all.deb
        dpkg -i zabbix-release_6.5-1+debian11_all.deb
    else
        echo "不支持的Debian版本: $OS_VERSION"
        exit 1
    fi
elif [[ "$ARCH" == "aarch64" ]]; then
    wget https://repo.zabbix.com/zabbix/6.5/debian-arm64/pool/main/z/zabbix-release/zabbix-release_6.5-2+debian12_all.deb
    dpkg -i zabbix-release_6.5-2+debian12_all.deb
else
    echo "不支持的架构: $ARCH"
    exit 1
fi

apt update
apt install zabbix-agent2 zabbix-agent2-plugin-*

sed -i 's/Server=127.0.0.1/Server=128.140.127.179/g' /etc/zabbix/zabbix_agent2.conf

systemctl restart zabbix-agent2
systemctl enable zabbix-agent2
