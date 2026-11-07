# zn-m2-build —— ZN-M2 (IPQ6018) 定制固件构建仓

LiBwrt 25.12-nss 底座（qualcommax/ipq60xx 原生支持 zn_m2）
+ ImmortalWrt openwrt-25.12 钉版 feeds + 自有 fw-feed（gecoosac/nc-provision）。

## 用途定位
试验田/工程背包机（不进SKU）。网关角色基线：sqm-cake 整形 + tailscale + watchcat + 集客AC。

## 使用
1. Settings → Actions → General → Workflow permissions → **Read and write**
2. Actions 页手动运行 `ZN-M2-25.12-NOWIFI`（约 60-90 分钟）
3. 首次构建：从日志抄 `gecoosac sha256` 回填 `fw-feed/net/gecoosac/Makefile` 的 `PKG_HASH:=skip`，
   并把底座 commit（release 正文中的 PINNED_HEAD）记入 PIN.lock
4. Releases 页下载 `*-squashfs-sysupgrade.bin`（sha256sums 附件核对）

## 刷机（ZN-M2 现网 192.168.5.1，串口 COM9 已备）
```
# 备份
uci export network dhcp wireless tailscale > /tmp/pre-flush-backup.uci  # scp 回本地
# 校验后 sysupgrade（不带 -u，全新配置；provision 首启自动 5.1 化）
sysupgrade -v /tmp/openwrt-qualcommax-ipq60xx-arm-*-zn_m2-squashfs-sysupgrade.bin
```
首启后：串口盯启动 → 设 root 密码 → tailscale up → gecoosac 60650 可达。

## 固定项
- 内核 6.12 NSS（IPQ60xx）；LuCI；rootfs 编译后有 24MB 红线闸门
- gecoosac 二进制=闭源原厂（lwb1978 删库后双镜像 ly/hx，CI 互为备份拉取）
