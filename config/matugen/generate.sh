#!/usr/bin/env bash
set -euo pipefail

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
WALLPAPER=${1:-"/home/shyweeds/dotfiles/assets/wallpaper/1.png"}
CFG="$DIR/config.toml"
OUT="$DIR/output"

mkdir -p "$OUT"
echo "▸ generating colors from $WALLPAPER …"
matugen image "$WALLPAPER" --config "$CFG" --mode dark

# Hot-reload running apps (ignore failures)
pkill -SIGUSR1 -x kitty 2>/dev/null || true
pkill -SIGUSR2 -x waybar 2>/dev/null || true
pgrep -x swaync >/dev/null && swaync-client --reload-css
pgrep -x swayosd >/dev/null && swayosd-client --reload-css
# GTK re-read theme (recommended post_hook)
gsettings set org.gnome.desktop.interface gtk-theme "" 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-dark 2>/dev/null || true
# fuzzel & hyprlock have no daemon, takes effect on next launch

echo "✔ colors updated; apps reloaded where possible."
