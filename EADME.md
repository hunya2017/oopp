# ImmortalWrt 自定义固件编译

这个项目使用 GitHub Actions 自动编译 ImmortalWrt 固件，并应用自定义的默认设置。

## 🚀 功能特性

### 自定义默认配置
- **管理地址**: 192.168.10.1
- **用户名**: root
- **密码**: password
- **WiFi SSID**: ImmortalWrt-WiFi / ImmortalWrt-WiFi-5G
- **WiFi密码**: 12345678
- **语言**: 中文界面
- **时区**: 亚洲/上海

### 预装功能
- 中文 Web 管理界面
- 优化的网络配置
- 自动时间同步（中国 NTP 服务器）
- 基础网络工具和诊断工具
- USB 存储支持
- 系统管理脚本

### 编译特性
- 基于最新的 ImmortalWrt 源码
- 支持缓存加速编译
- 自动发布到 GitHub Releases
- 详细的编译日志和调试信息

## 📁 文件结构

```
├── .github/workflows/
│   └── immortalwrt-all.yml        # GitHub Actions 工作流
├── smpackage/
│   ├── immortalwrt-all-1.sh       # 编译前脚本1
│   ├── immortalwrt-all-2.sh       # 编译前脚本2
│   ├── patch1.patch               # Makefile 补丁
│   └── 99-my-default-settings     # 自定义设置脚本
├── config/
│   └── immortalwrt.info           # 编译配置文件
└── README.md                       # 说明文档
```

## 🛠️ 使用方法

### 1. Fork 此项目
点击右上角的 "Fork" 按钮，将项目复制到你的 GitHub 账户。

### 2. 配置 Secrets
在你的仓库设置中，添加以下 Secrets：
- `GIT_USER_TOKEN`: GitHub Personal Access Token (用于发布 Releases)

### 3. 启动编译
有以下几种方式启动编译：

#### 方式一：手动触发
1. 进入 Actions 页面
2. 选择 "immortalwrt-all" 工作流
3. 点击 "Run workflow"
4. 根据需要调整选项后点击 "Run workflow"

#### 方式二：Watch 触发
Star 这个项目即可触发编译。

#### 方式三：定时编译
取消注释 workflow 文件中的 schedule 部分，设置定时编译。

### 4. 编译选项说明
- **缓存加速**: 启用编译缓存，加速后续编译
- **上传固件**: 上传编译好的固件文件
- **上传配置文件**: 上传编译配置和信息文件
- **上传插件**: 上传编译的 IPK 插件包
- **发布到 Releases**: 自动发布固件到 GitHub Releases
- **SSH 连接**: 编译过程中启用 SSH 调试（仅调试时使用）

## ⚙️ 自定义配置

### 修改默认设置
编辑 `smpackage/99-my-default-settings` 文件来修改：
- 默认 IP 地址
- WiFi 配置
- 系统密码
- 时区设置
- 其他系统配置

### 修改软件包
编辑 `config/immortalwrt.info` 文件来：
- 添加或移除软件包
- 启用或禁用功能
- 修改编译选项

### 添加自定义补丁
将补丁文件放在 `smpackage/` 目录下，并在脚本中应用。

### 修改编译脚本
- `immortalwrt-all-1.sh`: 在下载源码后执行的脚本
- `immortalwrt-all-2.sh`: 在配置生成后执行的脚本

## 📋 编译信息

### 支持的设备
- x86_64 设备（虚拟机、软路由、PC等）
- 其他设备需要修改配置文件中的目标平台

### 编译环境
- Ubuntu 22.04 LTS
- 多线程编译
- 缓存加速支持

### 编译输出
编译完成后会生成以下文件：
- 固件镜像文件 (.img, .vmdk, .vdi 等)
- 软件包文件 (.ipk)
- 配置信息文件
- 编译日志

## 🔧 管理命令

固件内置了以下管理命令：

```bash
# 重置 WiFi 密码为默认值
reset-wifi

# 重置网络配置为默认值  
reset-network
```

## 📝 默认配置信息

### 网络配置
```
LAN IP: 192.168.10.1/24
DHCP 范围: 192.168.10.100-250
DHCP 租期: 12小时
DNS: 自动获取
```

### WiFi 配置
```
2.4G SSID: ImmortalWrt-WiFi
5G SSID: ImmortalWrt-WiFi-5G
密码: 12345678
加密: WPA2-PSK
```

### 系统配置
```
主机名: ImmortalWrt-Custom
时区: Asia/Shanghai (CST-8)
语言: 简体中文
NTP 服务器: 阿里云 NTP
```

## 🐛 问题排查

### 编译失败
1. 检查 GitHub Actions 日志
2. 确认配置文件语法正确
3. 检查是否有冲突的软件包配置
4. 尝试启用 SSH 调试模式

### 固件问题
1. 检查设备兼容性
2. 确认固件完整性
3. 尝试恢复出厂设置
4. 查看系统日志

### 网络问题
1. 检查网线连接
2. 确认 IP 地址配置
3. 重置网络配置
4. 检查防火墙规则

## 📖 相关链接

- [ImmortalWrt 官网](https://immortalwrt.org/)
- [ImmortalWrt GitHub](https://github.com/immortalwrt/immortalwrt)
- [OpenWrt 官方文档](https://openwrt.org/docs/start)
- [LuCI 项目](https://github.com/openwrt/luci)

## 📄 许可证

本项目遵循 GPL-2.0 许可证。详情请参阅 [LICENSE](LICENSE) 文件。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。

---

**注意**: 使用本固件需要一定的网络基础知识。首次使用建议在测试环境中进行。