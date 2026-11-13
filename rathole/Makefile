#
# Copyright (C) 2026 OpenWrt.org
#
# This is free software, licensed under the Apache License, Version 2.0.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rathole
PKG_VERSION:=0.5.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/rathole-org/rathole.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_MIRROR_HASH:=skip

PKG_MAINTAINER:=OpenWrt Community
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_PARALLEL:=1

# 目标三元组与 Cargo 环境变量名映射
ifeq ($(ARCH),aarch64)
  RUST_TARGET:=aarch64-unknown-linux-musl
  RUST_ENV_TRIPLE:=AARCH64_UNKNOWN_LINUX_MUSL
endif
ifeq ($(ARCH),x86_64)
  RUST_TARGET:=x86_64-unknown-linux-musl
  RUST_ENV_TRIPLE:=X86_64_UNKNOWN_LINUX_MUSL
endif
ifeq ($(ARCH),arm)
  RUST_TARGET:=armv7-unknown-linux-musleabihf
  RUST_ENV_TRIPLE:=ARMV7_UNKNOWN_LINUX_MUSLEABIHF
endif
ifeq ($(ARCH),mips)
  RUST_TARGET:=mips-unknown-linux-musl
  RUST_ENV_TRIPLE:=MIPS_UNKNOWN_LINUX_MUSL
endif
ifeq ($(ARCH),mipsel)
  RUST_TARGET:=mipsel-unknown-linux-musl
  RUST_ENV_TRIPLE:=MIPSEL_UNKNOWN_LINUX_MUSL
endif

include $(INCLUDE_DIR)/package.mk

define Package/rathole
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Routing and Redirection
  TITLE:=A lightweight and high-performance reverse proxy for NAT traversal
  URL:=https://github.com/rathole-org/rathole
  DEPENDS:=
endef

define Package/rathole/description
  rathole is a secure, stable and high-performance reverse proxy for NAT traversal,
  written in Rust. It serves as an ultra-lightweight alternative to frp and ngrok,
  optimized for minimal memory footprint and binary size on embedded devices.
endef

define Build/Compile
	cd $(PKG_BUILD_DIR) && \
	rm -f rust-toolchain rust-toolchain.toml && \
	cargo update -p time --precise 0.3.36 && \
	env -u PKG_CONFIG_PATH -u PKG_CONFIG_LIBDIR -u LIBRARY_PATH \
		CARGO_TARGET_DIR="$(PKG_BUILD_DIR)/target" \
		PATH="$(TOOLCHAIN_DIR)/bin:$(PATH)" \
		CARGO_TARGET_$(RUST_ENV_TRIPLE)_LINKER="$(TARGET_CROSS)gcc" \
	cargo build \
		--target $(RUST_TARGET) \
		--profile minimal \
		--no-default-features \
		--features "embedded"
endef

define Package/rathole/install
	$(INSTALL_DIR) $(1)/usr/bin
	if [ -f $(PKG_BUILD_DIR)/target/$(RUST_TARGET)/minimal/rathole ]; then \
		$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUST_TARGET)/minimal/rathole $(1)/usr/bin/rathole ; \
	else \
		$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUST_TARGET)/release/rathole $(1)/usr/bin/rathole ; \
	fi
endef

$(eval $(call BuildPackage,rathole))