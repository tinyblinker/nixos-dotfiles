#!/usr/bin/env bash
# Use ImageMagick to generate a blurred 1-blur.png from 1.png (for niri overview backdrop)
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
