const fs = require('fs');

const filePath = '.github/workflows/openwrt-r3s.yml';
let content = fs.readFileSync(filePath, 'utf8');

// 查找旧的步骤内容并替换
const lines = content.split('\n');
const newLines = [];
let i = 0;
let foundStep = false;

while (i < lines.length) {
  const line = lines[i];
  
  // 找到目标步骤的开始
  if (line.includes('- name: 安装源和修改默认设置')) {
    foundStep = true;
    
    // 添加新的步骤内容
    newLines.push('    - name: 安装源和修改默认设置');
    newLines.push('      run: |');
    newLines.push('        cd openwrt');
    newLines.push('        ./scripts/feeds install -a');
    newLines.push('');
    newLines.push('        echo "=== 开始修改默认设置文件 ==="');
    newLines.push('');
    newLines.push('        # 使用正确的uci-defaults目录路径');
    newLines.push('        UCI_DEFAULTS_PATH="package/base-files/files/etc/uci-defaults"');
    newLines.push('');
    newLines.push('        # 检查uci-defaults目录是否存在');
    newLines.push('        if [ ! -d "$UCI_DEFAULTS_PATH" ]; then');
    newLines.push('          echo "错误：未找到uci-defaults目录：$UCI_DEFAULTS_PATH"');
    newLines.push('          exit 1');
    newLines.push('        fi');
    newLines.push('');
    newLines.push('        # 直接将settings.patch复制到uci-defaults目录并重命名为99-default-settings');
    newLines.push('        if [ -e "$GITHUB_WORKSPACE/$SETTINGS_PATCH" ]; then');
    newLines.push('          echo "复制settings.patch到uci-defaults目录..."');
    newLines.push('          cp "$GITHUB_WORKSPACE/$SETTINGS_PATCH" "$UCI_DEFAULTS_PATH/99-default-settings"');
    newLines.push('          chmod +x "$UCI_DEFAULTS_PATH/99-default-settings"');
    newLines.push('          echo "✓ 已成功复制并设置执行权限"');
    newLines.push('        else');
    newLines.push('          echo "⚠ 未找到settings.patch文件，跳过自定义设置"');
    newLines.push('        fi');
    newLines.push('');
    newLines.push('        echo "=== 修改完成，显示最终文件内容 ==="');
    newLines.push('        if [ -f "$UCI_DEFAULTS_PATH/99-default-settings" ]; then');
    newLines.push('          echo "文件内容:"');
    newLines.push('          cat "$UCI_DEFAULTS_PATH/99-default-settings"');
    newLines.push('        fi');
    
    // 跳过旧的步骤内容，直到找到下一个步骤
    i++;
    while (i < lines.length && !lines[i].includes('- name: 执行自定义脚本2')) {
      i++;
    }
    // 回退一行，因为下一个步骤也需要被添加
    i--;
  } else {
    newLines.push(line);
  }
  
  i++;
}

if (foundStep) {
  fs.writeFileSync(filePath, newLines.join('\n'), 'utf8');
  console.log('✓ 文件已成功更新!');
} else {
  console.log('✗ 未找到目标步骤');
}
