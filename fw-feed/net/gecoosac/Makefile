include $(TOPDIR)/rules.mk

PKG_NAME:=gecoosac
PKG_VERSION:=2.2.20251015
PKG_RELEASE:=1

PKG_ARCH:=arm64
# 上游 lwb1978 已删库；镜像源（同一二进制，两镜像尺寸一致 16318648B）：
#   ly: https://github.com/lyin888/gecoosac-core/releases/tag/V2.2.202510151606
#   hx: https://github.com/hxlls/gecoosac-core/releases/tag/V2.2.20251015
# 双镜像互备：主用 ly，失败 CI 内换 hx（见 workflow 的 dl 预备步骤）。
PKG_SOURCE:=ac_linux_arm64
PKG_SOURCE_URL:=https://github.com/lyin888/gecoosac-core/releases/download/V2.2.202510151606
# 首构建自举：CI 打印 sha256 后，回填此处并把 download step 的 skip 关掉
PKG_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/gecoosac
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Gecoos AC (JiKe AC controller, prebuilt)
  URL:=https://github.com/lyin888/gecoosac-core
  DEPENDS:=+libpthread
endef

define Package/gecoosac/description
  JiKe (gecoos) wireless AC controller, static Go binary from upstream release.
endef

define Build/Compile
  # prebuilt: no compile
endef

define Build/Install
  mkdir -p $(PKG_INSTALL_DIR)/usr/bin
  install -m 0755 $(PKG_BUILD_DIR)/$(PKG_SOURCE) $(PKG_INSTALL_DIR)/usr/bin/gecoosac
endef

define Package/gecoosac/install
  install -d $(1)/usr/bin $(1)/etc/init.d $(1)/etc/gecoosac
  install -m 0755 $(PKG_INSTALL_DIR)/usr/bin/gecoosac $(1)/usr/bin/
  install -m 0755 files/gecoosac.initd $(1)/etc/init.d/gecoosac
endef

$(eval $(call BuildPackage,gecoosac))
