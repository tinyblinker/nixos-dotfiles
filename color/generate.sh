#!/usr/bin/env bash
# 用 matugen 从壁纸生成 kitty/dunst/fuzzel/waybar 的颜色文件到 ./color/,并热重载。
# 用法: ./color/generate.sh [壁纸路径]   默认使用 wallpaper/1.png
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
wallpaper="${1:-$dir/../wallpaper/1.png}"

matugen image "$wallpaper" --config "$dir/config.toml" --mode dark

# 热重载各应用(存在才重载,失败忽略)
kill -SIGUSR1 "$(pgrep -x kitty)" 2>/dev/null || true   # kitty 重载配置
pkill -SIGUSR2 -x waybar 2>/dev/null || true            # waybar 重载样式
dunstctl reload 2>/dev/null || true                     # dunst 重载配置
# fuzzel 无常驻进程,下次打开即生效

echo "colors regenerated from: $wallpaper"
