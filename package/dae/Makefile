include $(TOPDIR)/rules.mk

PKG_NAME:=dae
PKG_VERSION:=2.0.0rc1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/daeuniverse/dae/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=BB5AB4699CF05CF4E5C6695F0CA0870FFCAA01037CF9809E48FD6D8E4EF03B61

PKG_MAINTAINER:=OpenWrt Build <build@local>
PKG_LICENSE:=AGPL-3.0-only
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/daeuniverse/dae

TAR_OPTIONS+= --strip-components 1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/lang/golang/golang-package.mk

define Package/dae
  SECTION:=net
  CATEGORY:=Network
  TITLE:=dae - high-performance transparent proxy solution
  URL:=https://github.com/daeuniverse/dae
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/dae/description
  dae is a high-performance transparent proxy solution using eBPF for traffic splitting and proxy acceleration.
endef

define Package/dae/install
        $(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
        $(INSTALL_DIR) $(1)/usr/bin
        $(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dae $(1)/usr/bin/
          # install default config
          $(INSTALL_DIR) $(1)/etc/dae
          $(INSTALL_DATA) $(CURDIR)/files/dae.yaml $(1)/etc/dae/dae.yaml

          # install init script
          $(INSTALL_DIR) $(1)/etc/init.d
          $(INSTALL_BIN) $(CURDIR)/files/dae.init $(1)/etc/init.d/dae
endef

$(eval $(call GoBinPackage,dae))
$(eval $(call BuildPackage,dae))
