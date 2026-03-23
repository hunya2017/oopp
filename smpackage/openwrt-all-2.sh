#!/bin/bash

# OpenWrt编译前自定义脚本2
# 在执行make menuconfig之前执行

echo "=== OpenWrt编译前自定义脚本2开始执行 ==="

# 显示当前工作目录
echo "当前目录：$(pwd)"
echo "执行时间：$(date)"

# ===== 加载预定义的.config配置文件 =====
if [ -f ".config" ]; then
    echo "✓ 已存在.config文件"
else
    echo "⚠ .config文件不存在，将使用默认配置"
fi

# ===== 修改默认主题和语言设置 =====
echo "修改默认语言和主题设置..."

# 启用中文支持
sed -i 's/# CONFIG_PACKAGE_luci-i18n-base-zh-cn is not set/CONFIG_PACKAGE_luci-i18n-base-zh-cn=y/' .config
sed -i 's/# CONFIG_PACKAGE_luci-i18n-admin-guide-zh-cn is not set/CONFIG_PACKAGE_luci-i18n-admin-guide-zh-cn=y/' .config

echo "✓ 已启用中文语言包"

# ===== 添加常用插件配置 =====
echo "添加常用插件配置..."

# 以下配置需要根据实际需求调整
# cat >> .config << 'EOF'

# # 常用LuCI应用
# CONFIG_PACKAGE_luci-app-opkg=y
# CONFIG_PACKAGE_luci-app-firewall=y
# CONFIG_PACKAGE_luci-app-upnp=y
# CONFIG_PACKAGE_luci-app-adbyby-plus=y
# CONFIG_PACKAGE_luci-app-ddns=y
# CONFIG_PACKAGE_luci-app-wol=y
# CONFIG_PACKAGE_luci-app-arpbind=y
# CONFIG_PACKAGE_luci-app-autoreboot=y

# # 网络工具
# CONFIG_PACKAGE_luci-app-nat6-helper=y
# CONFIG_PACKAGE_luci-app-netcut=y
# CONFIG_PACKAGE_luci-app-network=y

# # 系统工具
# CONFIG_PACKAGE_luci-app-system=y
# CONFIG_PACKAGE_luci-app-log=y
# CONFIG_PACKAGE_luci-app-cpu-status=y

# EOF

echo "✓ 插件配置已添加"

# ===== 优化编译选项 =====
echo "优化编译选项..."

# 禁用不必要的功能以减小固件体积
cat >> .config << 'EOF'

# 优化选项
CONFIG_KERNEL_KALLSYMS=n
CONFIG_KERNEL_DEBUG_INFO=n
CONFIG_KERNEL_DEBUG_FS=n
CONFIG_KERNEL_PROC_PAGE_MONITOR=n

# 精简内核模块
CONFIG_PACKAGE_kmod-lib-crc32c=n
CONFIG_PACKAGE_kmod-fs-ext4=n

EOF

echo "✓ 编译选项已优化"

# ===== 显示最终配置摘要 =====
echo ""
echo "=== 配置摘要 ==="
echo "总行数：$(wc -l < .config)"
echo "启用的包数量：$(grep -c "^CONFIG_" .config)"
echo "禁用的包数量：$(grep -c "^# CONFIG_" .config)"
echo ""

# ===== 生成最终的defconfig =====
echo "生成defconfig..."
make defconfig

echo "=== OpenWrt编译前自定义脚本2执行完毕 ==="
echo "准备开始编译..."
