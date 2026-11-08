include $(TOPDIR)/rules.mk

PKG_NAME:=nc-provision
PKG_VERSION:=1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/nc-provision
	SECTION:=net
	CATEGORY:=Network
	TITLE:=First-boot provisioning (LAN/dhcp/tailscale bootstrap)
endef

define Package/nc-provision/description
	Idempotent first-boot script: LAN ip, dhcp pool, hostname, root pw check,
	tailscale bootstrap marker. Safe to run repeatedly.
endef

define Build/Compile
	true
endef

define Package/nc-provision/install
	install -d $(1)/etc/init.d $(1)/usr/sbin
	install -m 0755 files/provision.initd $(1)/etc/init.d/nc-provision
	install -m 0755 files/provision.sh $(1)/usr/sbin/nc-provision
endef

$(eval $(call BuildPackage,nc-provision))
