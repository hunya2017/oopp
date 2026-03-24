const fs = require('fs');

const filePath = '.github/workflows/openwrt-r3s.yml';
let content = fs.readFileSync(filePath, 'utf8');

const oldStep = `    - name: 安装源和修改默认设置
      run: |
        cd openwrt
        ./scripts/feeds install -a

        echo "=== 开始修改默认设置文件 ==="

        # 使用正确的 uci-defaults 目录路径
        UCI_DEFAULTS_PATH="package/base-files/files/etc/uci-defaults"
        if [ -d "$UCI_DEFAULTS_PATH" ]; then
          cd "$UCI_DEFAULTS_PATH"

          # 检查是否存在 99-default-settings文件
          if [ -f "99-default-settings" ]; then
            echo "✓ 找到 99-default-settings文件"
            cp 99-default-settings 99-default-settings.bak
          else
            echo "⚠ 未找到 99-default-settings文件，将创建新文件"
            cat > 99-default-settings << 'BASEEOF'
            #!/bin/sh
            # === ImmortalWrt-Custom自定义设置 ===
            uci set system.@system[0].timezone='CST-8'
            uci set system.@system[0].zonename='Asia/Shanghai'
            uci set network.lan.ipaddr='192.168.10.1'
            uci set network.lan.dhcp.start='192.168.10.100'
            uci set network.lan.dhcp.limit='150'
            uci set network.lan.dhcp.leasetime='12h'
            echo 'root:password' | chpasswd
            uci set wireless.@wifi-device[0].disabled='0'
            uci commit
            echo "✓ 自定义设置已完成"
            exit 0
            BASEEOF
              fi
              chmod +x 99-default-settings
              echo "✓ 已设置执行权限"
          
          # 应用patch文件（如果存在）
          if [ -e "$GITHUB_WORKSPACE/$SETTINGS_PATCH" ]; then
            echo "尝试应用patch文件..."
            cp "$GITHUB_WORKSPACE/$SETTINGS_PATCH" ./settings.patch
            
            if patch --dry-run -p1 < settings.patch >/dev/null 2>&1; then
              patch -p1 < settings.patch
              echo "✓ patch应用成功"
            else
              echo "⚠ patch应用失败，使用默认配置"
            fi
          fi
        else
          echo "错误：未找到uci-defaults目录：$UCI_DEFAULTS_PATH"
          exit 1
        fi

        echo "=== 修改完成，显示最终文件内容 ==="
        if [ -f "$UCI_DEFAULTS_PATH/99-default-settings" ]; then
          echo "文件内容:"
          cat "$UCI_DEFAULTS_PATH/99-default-settings"
        fi

    - name: 执行自定义脚本2`;

const newStep = `    - name: 安装源和修改默认设置
      run: |
        cd openwrt
        ./scripts/feeds install -a

        echo "=== 开始修改默认设置文件 ==="

        # 使用正确的uci-defaults目录路径
        UCI_DEFAULTS_PATH="package/base-files/files/etc/uci-defaults"
        
        # 检查uci-defaults目录是否存在
        if [ ! -d "$UCI_DEFAULTS_PATH" ]; then
          echo "错误：未找到uci-defaults目录：$UCI_DEFAULTS_PATH"
          exit 1
        fi

        # 直接将settings.patch复制到uci-defaults目录并重命名为99-default-settings
        if [ -e "$GITHUB_WORKSPACE/$SETTINGS_PATCH" ]; then
          echo "复制settings.patch到uci-defaults目录..."
          cp "$GITHUB_WORKSPACE/$SETTINGS_PATCH" "$UCI_DEFAULTS_PATH/99-default-settings"
          chmod +x "$UCI_DEFAULTS_PATH/99-default-settings"
          echo "✓ 已成功复制并设置执行权限"
        else
          echo "⚠ 未找到settings.patch文件，跳过自定义设置"
        fi

        echo "=== 修改完成，显示最终文件内容 ==="
        if [ -f "$UCI_DEFAULTS_PATH/99-default-settings" ]; then
          echo "文件内容:"
          cat "$UCI_DEFAULTS_PATH/99-default-settings"
        fi

    - name: 执行自定义脚本2`;

const newContent = content.replace(oldStep, newStep);

if (newContent === content) {
  console.log('✗ 未找到匹配的内容，替换失败');
  process.exit(1);
}

fs.writeFileSync(filePath, newContent, 'utf8');
console.log('✓ 文件已成功更新!');
