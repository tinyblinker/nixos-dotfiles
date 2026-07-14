#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
WALLPAPER=${1:-"/home/shyweeds/dotfiles/assets/wallpaper/1.png"}
CFG="$DIR/config.toml"
OUT="$DIR/output"

mkdir -p "$OUT"
echo "▸ generating colors from $WALLPAPER …"
matugen image "$WALLPAPER" --config "$CFG" --mode dark

# 热重载各应用(存在才 reload,失败忽略)
pkill -SIGUSR1 -x kitty 2>/dev/null || true
pkill -SIGUSR2 -x waybar 2>/dev/null || true
makoctl reload 2>/dev/null || true
swaync-client --reload-css 2>/dev/null || true
swayosd-client --reload-css 2>/dev/null || true
# GTK 重读主题(官方推荐 post_hook)
gsettings set org.gnome.desktop.interface gtk-theme "" 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark 2>/dev/null || true
# fuzzel & hyprlock 无常驻进程,下次启动生效

echo "✔ colors updated; apps reloaded where possible."
