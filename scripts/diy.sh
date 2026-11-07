#!/bin/bash
# diy 钩子：在 feeds install 之后、defconfig 之前执行
# 1) 保证 ncfeed 与自定义软件包目录就位（workflow 已拷贝，这里兜底校验）
set -e
[ -d package/feeds/ncfeed ] || { echo "FATAL: ncfeed not installed"; exit 1; }

# 2) rootfs 预算警示（24MB rootfs 卷红线；实际检查在编译后步骤）
echo "INFO: diy done. rootfs budget check happens post-build."
