# PPPoE 拨号配置指南

## 概述

本固件支持 PPPoE 拨号功能，使用环境变量安全地存储账号密码，避免明文凭证出现在代码仓库中。

## 配置步骤

### 1. 在 GitHub 仓库中设置 Secrets

1. 打开您的 GitHub 仓库页面
2. 点击 **Settings**（设置）标签
3. 在左侧菜单中选择 **Secrets and variables** → **Actions**
4. 点击 **New repository secret**（新建仓库密钥）按钮
5. 添加以下两个密钥：

   | Name（名称） | Value（值） | Description（描述） |
   |-------------|------------|-------------------|
   | `PPPOE_USERNAME` | 您的宽带账号 | PPPoE 拨号用户名 |
   | `PPPOE_PASSWORD` | 您的宽带密码 | PPPoE 拨号密码 |

6. 点击 **Add secret** 保存每个密钥

### 2. 触发固件编译

设置完 Secrets 后，下次编译固件时会自动使用这些凭证配置 PPPoE 拨号。

您可以通过以下方式触发编译：
- 手动触发 workflow
- 等待定时任务自动执行
- 推送新的 commit

### 3. 验证配置

固件刷入后，可以通过以下方式验证 PPPoE 配置：

```bash
# SSH 登录路由器
ssh root@192.168.10.1

# 查看网络配置
uci show network.wan

# 应该看到类似输出：
# network.wan.proto='pppoe'
# network.wan.username='您的账号'
# network.wan.password='您的密码'
```

## 工作原理

### 环境变量读取

在 [`smpackage/settings.patch`](smpackage/settings.patch) 文件中：

```bash
# 从环境变量读取 PPPoE 凭证（如果未设置则为空）
pppoe_username="${PPPOE_USERNAME:-}"
pppoe_password="${PPPOE_PASSWORD:-}"
```

### 首次启动检测

系统会检查 `/etc/.first_boot_marker` 标记文件：

- **首次启动**（标记文件不存在）：
  - 如果设置了环境变量 → 配置 PPPoE
  - 创建标记文件
  - 应用其他初始配置

- **非首次启动**（标记文件存在）：
  - 跳过 PPPoE 配置
  - 保留用户的网络设置
  - 防止升级时覆盖用户配置

### GitHub Actions 集成

在 workflow 文件中， Secrets 会自动作为环境变量注入：

```yaml
# GitHub Actions 会自动暴露 Secrets 为环境变量
# PPPOE_USERNAME 和 PPPOE_PASSWORD 可直接使用
```

## 安全注意事项

✅ **推荐做法：**
- 使用 GitHub Secrets 存储敏感信息
- 不在代码仓库中提交包含明文密码的文件
- 定期更换密码并更新 Secrets

❌ **避免做法：**
- 不要将密码直接写入 `settings.patch` 或其他脚本
- 不要在 commit message 中包含密码
- 不要在日志中打印密码信息

## 故障排查

### 问题：PPPoE 未自动配置

**检查清单：**
1. 确认 Secrets 已正确设置
   - 进入 **Settings** → **Secrets and variables** → **Actions**
   - 验证 `PPPOE_USERNAME` 和 `PPPOE_PASSWORD` 存在

2. 检查是否是首次启动
   ```bash
   ls -la /etc/.first_boot_marker
   ```
   如果文件存在，PPPoE 不会重新配置

3. 查看日志
   ```bash
   cat /etc/rc.local
   dmesg | grep -i pppoe
   ```

### 问题：需要更改 PPPoE 账号

**解决方案：**
1. 在 GitHub Secrets 中更新 `PPPOE_USERNAME` 和 `PPPOE_PASSWORD`
2. 删除路由器上的标记文件（如果需要重新应用配置）：
   ```bash
   rm /etc/.first_boot_marker
   ```
3. 重新刷入固件或重启路由器

## 不使用 PPPoE？

如果您不需要 PPPoE 拨号（例如使用 DHCP 或静态 IP）：

- **无需任何操作**：不设置 Secrets 即可
- 固件会自动检测环境变量为空
- 不会配置 PPPoE，保持默认的网络设置

## 相关文件

- [`smpackage/settings.patch`](smpackage/settings.patch) - 包含 PPPoE 配置逻辑
- [`.github/workflows/immortalwrt-r3s.yml`](.github/workflows/immortalwrt-r3s.yml) - 编译工作流

## 技术支持

如有问题，请查看：
- ImmortalWrt 官方文档
- OpenWrt PPPoE 配置指南
- GitHub Actions Secrets 文档
