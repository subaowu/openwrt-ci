#!/bin/bash
# diy 钩子：在 feeds install 之后、defconfig 之前执行
# 1) 保证 ncfeed 与自定义软件包目录就位（workflow 已拷贝，这里兜底校验）
set -e
[ -d package/feeds/ncfeed ] || { echo "FATAL: ncfeed not installed"; exit 1; }

# 2) NOWIFI：摘除平台默认包里的 WiFi 组件。
#    LiBwrt 给 qualcommax 的 DEFAULT_PACKAGES 强塞了 wpad-openssl 和 kmod-ath11k*，
#    其 mac80211 的 ath11k 打了 NSS offload 补丁、需要 NSS WiFi 驱动私有头 nss_api_if.h，
#    NOWIFI 集合不含该驱动 → 必炸。token 级 sed，不动整行（同行还有 kmod-dsa 等必需品）。
if [ -f target/linux/qualcommax/Makefile ]; then
  sed -i -E 's/(kmod-ath11k[a-z-]*|wpad-openssl|ath11k-firmware-[a-z0-9]*)[[:space:]]*//g' target/linux/qualcommax/Makefile
  grep -c 'ath11k' target/linux/qualcommax/Makefile | xargs -I{} echo "INFO: ath11k 残留引用行数={} (应为0)"
fi

# 3) rootfs 预算警示（24MB rootfs 卷红线；实际检查在编译后步骤）
echo "INFO: diy done. rootfs budget check happens post-build."
