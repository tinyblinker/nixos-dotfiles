#!/usr/bin/env bash
# 用 ImageMagick 把 1.png 生成模糊版 1-blur.png(供 niri overview backdrop 使用)
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$dir/1.png"
dst="$dir/1-blur.png"

if [[ ! -f "$src" ]]; then
	echo "error: $src not found" >&2
	exit 1
fi

magick "$src" -blur 0x25 -brightness-contrast -10x0 "$dst"
echo "generated: $dst"
