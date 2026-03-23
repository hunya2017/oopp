#!/bin/bash

# OpenWrt编译前自定义脚本1
# 在更新feeds 之前执行

echo "=== OpenWrt编译前自定义脚本 1开始执行 ==="

# 显示当前工作目录和基本信息
echo "当前目录：$(pwd)"
echo "系统信息：$(uname -a)"
echo "编译开始时间：$(date)"

# ===== 修改默认feeds 源 =====
echo "检查和修改feeds配置..."

if [ -f "feeds.conf.default" ]; then
    echo "原始feeds.conf.default内容:"
    cat feeds.conf.default
    
    # 备份原始配置
    cp feeds.conf.default feeds.conf.default.bak
    
    # 可以在这里添加自定义feeds 源
    # 添加kenzok8/jell插件库
    # 添加kenzok8/jell插件库
    echo "# kenzok8/jell 插件库" >> feeds.conf.default
    echo "src-git jell https://github.com/kenzok8/jell" >> feeds.conf.default
    # echo 'src-git custom https://github.com/your-username/your-packages.git' >> feeds.conf.default
    
    echo "修改后的 feeds.conf.default 内容:"
    cat feeds.conf.default
else
    echo "警告：feeds.conf.default文件不存在"
fi

# ===== 修改版本信息 =====
echo "修改版本信息..."

# OpenWrt原生版本使用banner文件
if [ -f "package/base-files/files/etc/banner" ]; then
    echo "找到banner 文件: package/base-files/files/etc/banner"
    
    # 备份原文件
    cp package/base-files/files/etc/banner package/base-files/files/etc/banner.bak
    
    # 可以自定义banner内容
    cat > package/base-files/files/etc/banner << 'EOF'
       ____                 _       __     __        ____      _       
      / __ \____  ___  ____| |     / /____/ /_      / __ )___ | | _____
     / / / / __ \/ _ \/ __ \ | /| / / ___/ __/_____/ __  / _ \| |/ / _ \
    / /_/ / /_/ /  __/ / / / |/ |/ / /  / /_/_____/ /_/ / (_) |   <  __/
    \____/ .___/\___/_/ /_/|__/|__/_/   \__/     /_____/\___/|_|\_\___/
        /_/                    C H I N A   E D I T I O N
    
    =============================================================
    基于OpenWrt v24.10.0构建
    编译时间：$(TZ='Asia/Shanghai' date +"%Y-%m-%d %H:%M")
    管理地址：http://192.168.8.1
    用户名：root
    密码：password
    =============================================================
EOF
    
    echo "✓ Banner已更新"
else
    echo "⚠ 未找到banner文件"
fi

# ===== 添加额外的软件包源 =====
echo "检查额外软件包源..."

# 如果需要添加第三方插件，可以在这里添加
# mkdir -p package/custom
# cd package/custom
# git clone https://github.com/coolsnowwolf/lede/tree/master/package/lean luci-app-xxx
# cd -

echo "=== OpenWrt编译前自定义脚本1执行完毕 ==="
