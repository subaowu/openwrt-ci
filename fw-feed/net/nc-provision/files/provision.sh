#!/bin/sh
# 首刷幂等配置脚本 —— 只做"所有设备一致的出厂基线"，
# 客户个性化（SSID、AC纳管分组、OMR server 地址）走各自渠道，勿放此处。
# 每步先判断再改，可重复执行。
set -eu

LOG() { logger -t nc-provision -- "$1"; }

# 1) LAN IP / DHCP 池（与 ZN-M2 试验田当前定值一致，量产按 profile 调整）
LAN_IP="$(uci -q get network.lan.ipaddr || true)"
if [ "$LAN_IP" != "192.168.5.1" ]; then
    uci set network.lan.ipaddr='192.168.5.1'
    uci set network.lan.netmask='255.255.255.0'
    LOG "LAN ip -> 192.168.5.1 (was: ${LAN_IP:-unset})"
fi
uci set dhcp.lan.start='100'
uci set dhcp.lan.limit='150'
uci set dhcp.lan.leasetime='12h'
uci commit network
uci commit dhcp

# 2) 主机名按板型自动生成（便于现场识别；board_name 由内核传递）
MODEL="$(cat /tmp/sysinfo/board_name 2>/dev/null || echo unknown)"
echo "nc-${MODEL}" > /proc/sys/kernel/hostname
uci -q set system.@system[0].hostname="nc-${MODEL}" && uci commit system

# 3) root 空密码防线：空则打警告标记（不自动设默认密码——默认即弱点）
HASHF="$(awk -F: '$1=="root"{print $2}' /etc/shadow)"
if [ -z "$HASHF" ]; then
    touch /etc/nc-needs-rootpw
    LOG "WARN: root has no password; /etc/nc-needs-rootpw created"
fi

# 4) Tailscale 引导标记（装了才处理；up 操作留给装机流程，需人工 auth）
if [ -x /usr/bin/tailscale ]; then
    [ -f /etc/nc-ts-done ] || touch /etc/nc-ts-needed
fi

LOG "provision done"
exit 0
