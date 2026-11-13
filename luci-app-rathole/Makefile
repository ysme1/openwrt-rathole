include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-rathole
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_MAINTAINER:=OpenWrt Community
PKG_LICENSE:=Apache-2.0

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-rathole
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=LuCI support for Rathole
  PKGARCH:=all
  DEPENDS:=+rathole +luci-compat
endef

define Package/luci-app-rathole/description
  LuCI support for Rathole (High-performance reverse proxy for NAT traversal).
endef

define Package/luci-app-rathole/conffiles
/etc/config/rathole
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./luasrc $(PKG_BUILD_DIR)/
	$(CP) ./root $(PKG_BUILD_DIR)/
	[ ! -d ./po ] || $(CP) ./po $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-rathole/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) $(PKG_BUILD_DIR)/luasrc/* $(1)/usr/lib/lua/luci/
	$(INSTALL_DIR) $(1)/
	$(CP) $(PKG_BUILD_DIR)/root/* $(1)/
	chmod 755 $(1)/etc/init.d/rathole 2>/dev/null || true
	if [ -f $(PKG_BUILD_DIR)/po/zh-cn/rathole.po ] && command -v po2lmo >/dev/null 2>&1; then \
		$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n ; \
		po2lmo $(PKG_BUILD_DIR)/po/zh-cn/rathole.po $(1)/usr/lib/lua/luci/i18n/rathole.zh-cn.lmo ; \
	fi
endef

define Package/luci-app-rathole/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	chmod 755 /etc/init.d/rathole 2>/dev/null || true
	rm -f /tmp/luci-indexcache
	rm -rf /tmp/luci-modulecache/
	killall -HUP rpcd 2>/dev/null
	/etc/init.d/rathole enable 2>/dev/null || true
	exit 0
}
endef

$(eval $(call BuildPackage,luci-app-rathole))
