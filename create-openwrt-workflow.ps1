# Copy and modify workflow file
$source = "g:\GitHub\oopp\.github\workflows\immortalwrt-r3s.yml"
$dest = "g:\GitHub\oopp\.github\workflows\openwrt-r3s.yml"

$content = Get-Content $source -Raw

# Replace ImmortalWrt specific values with OpenWrt equivalents
$content = $content -replace 'immortalwrt-r3s', 'openwrt-r3s'
$content = $content -replace 'https://github.com/immortalwrt/immortalwrt', 'https://github.com/openwrt/openwrt'
$content = $content -replace 'REPO_BRANCH: openwrt-24.10', 'REPO_BRANCH: v24.10.0'
$content = $content -replace 'CONFIG_FILE: config/immortalwrt.info', 'CONFIG_FILE: config/openwrt.info'
$content = $content -replace 'Firmware_Name: immortalwrt-all', 'Firmware_Name: openwrt-all'
$content = $content -replace 'DIY_P1_SH: smpackage/immortalwrt-all-1.sh', 'DIY_P1_SH: smpackage/openwrt-all-1.sh'
$content = $content -replace 'DIY_P2_SH: smpackage/immortalwrt-all-2.sh', 'DIY_P2_SH: smpackage/openwrt-all-2.sh'
$content = $content -replace 'SETTINGS_PATCH: smpackage/settings.patch', 'SETTINGS_PATCH: #'

Set-Content -Path $dest -Value $content -Encoding UTF8
Write-Host "Created openwrt-r3s.yml successfully!"
