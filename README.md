<div align="center">

<img alt="NixOS" src="https://img.shields.io/badge/NixOS-26.05-5277C3?style=for-the-badge&logo=nixos&logoColor=white" />
<img alt="Status" src="https://img.shields.io/badge/status-🍚%20rice%20cooking-brightgreen?style=for-the-badge" />
<img alt="License" src="https://img.shields.io/github/license/tinyblinker/nixos-dotfiles?style=for-the-badge&color=blue" />
<br/>
<img alt="Stars" src="https://img.shields.io/github/stars/tinyblinker/nixos-dotfiles?style=social" />
<img alt="Last Commit" src="https://img.shields.io/github/last-commit/tinyblinker/nixos-dotfiles?style=social&color=purple" />

</div>

<h1 align="center">❄️ nixos-dotfiles</h1>

<p align="center">
  My personal <b>NixOS</b> + <b>Home Manager</b> config — <b>niri</b> scrolling-tiling Wayland compositor, dynamic wallpaper-based theming with <b>matugen</b>, and a clean modular structure.
</p>

---

## ⚠️ Setup Guide (Important — don't just clone and run)

This config is full of my personal machine's hardcoded paths and settings. If you clone it and run `nixos-rebuild switch` directly, it **will** break. Follow the steps below to make it yours.

### Step 1: Install NixOS and clone

```bash
# Install NixOS normally using the official ISO, then clone this repo
git clone https://github.com/tinyblinker/nixos-dotfiles.git ~/dotfiles
```

### Step 2: Replace the username everywhere

The config has my username `shyweeds` and home path `/home/shyweeds` hardcoded all over. Replace them with your own:

```bash
cd ~/dotfiles

# Replace all occurrences of "shyweeds" with your username
rg -l 'shyweeds' | xargs sed -i 's/shyweeds/yourname/g'

# Rename the home-manager module folder
mv modules/home/shyweeds modules/home/yourname
```

**Key files that reference the username:**

| File | What to change |
|:-----|:---------------|
| `flake.nix:31` | `users.yourname` |
| `modules/system/users.nix:3` | `users.users.yourname` |
| `modules/system/services.nix:7` | greetd `user` field |
| `modules/home/` folder name | Rename to your username |
| `modules/home/.../default.nix:2-3` | `home.username` & `home.homeDirectory` |

### Step 3: Regenerate hardware config

My `hardware-configuration.nix` contains my disk partitions, UUIDs, CPU microcode, etc. — **do not use it**:

```bash
# If installing fresh from ISO:
sudo nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix ~/dotfiles/hosts/nixos/hardware-configuration.nix

# If already on a running NixOS system:
sudo nixos-generate-config
cp /etc/nixos/hardware-configuration.nix ~/dotfiles/hosts/nixos/
# Then make sure configuration.nix imports this new file
```

### Step 4: Add a wallpaper

The wallpaper and matugen-generated color files are gitignored. You need to bring your own:

```bash
# Put your wallpaper here (must be named 1.png)
cp /path/to/your/wallpaper.png ~/dotfiles/assets/wallpaper/1.png

# Generate the blurred version (needs ImageMagick)
~/dotfiles/assets/wallpaper/blur.sh

# Generate color schemes for all apps from the wallpaper
~/dotfiles/config/matugen/generate.sh
```

> `blur.sh` needs `imagemagick`. If you don't have it: `nix-shell -p imagemagick`.

### Step 5: Set up mihomo proxy (or skip it)

`config/mihomo/config.yaml` is gitignored — it contains my subscription link and API key. You have three options:

1. **Use your own proxy** — drop your `config.yaml` in that folder
2. **Comment out mihomo** — edit `modules/system/network.nix` and comment out the mihomo block
3. **Remove mihomo entirely** — delete the mihomo input from `flake.nix` and its module imports

> If you skip the proxy, also update the Nix mirrors in `nix-settings.nix` (they're Chinese university mirrors).

### Step 6: Set up Git and SSH keys

`modules/home/yourname/git.nix` has my name, email, and SSH signing key path:

```nix
# Edit to match your own info:
user.name = "Your GitHub Username";
user.email = "your@email.com";
user.signingkey = "~/.ssh/id_ed25519.pub";  # your SSH key
```

If you don't have an SSH key yet:
```bash
ssh-keygen -t ed25519 -C "your@email.com"
```

### Step 7: Tweak hardware-specific settings

Go through these files and adjust anything that doesn't match your machine:

| File | What to check | How |
|:-----|:--------------|:----|
| `config/niri/config.kdl:17` | Display name `"eDP-1"` | Run `niri msg outputs` |
| `config/niri/config.kdl:106` | Screenshot path `~/Pictures/Screenshots/` | Make sure this folder exists |
| `modules/system/i18n.nix:3` | Timezone `Asia/Shanghai` | Change to your timezone |
| `hosts/nixos/configuration.nix:6` | Hostname `nixos` | Change to whatever |
| `modules/system/nix-settings.nix:12-18` | 5 Chinese Nix mirrors | Remove or replace if outside China |
| `modules/system/services.nix:22` | External keyboard USB ID `3554:fa09` | `lsusb` to find yours, or use `*:*` for all |
| `modules/home/yourname/battery-monitor.nix:11` | Battery device `BAT0` | `ls /sys/class/power_supply/` — ignore on desktops |

### Step 8: Set an initial password

`modules/system/users.nix` does **not** set a password. Add one:

```nix
# In modules/system/users.nix, inside users.users.yourname:
users.users.yourname = {
  initialPassword = "changeme";  # change it with passwd after first login
  # ...
};
```

### Step 9: Build and switch

```bash
# Rebuild the system (home-manager is embedded, no separate command needed)
sudo nixos-rebuild switch --flake ~/dotfiles#nixos

# After first boot, log in and change your password
passwd
```

Done 🎉

---

## 📋 Pre-flight Checklist

Before running the build, make sure you've:

- [ ] Replaced `shyweeds` with your username everywhere
- [ ] Renamed `modules/home/shyweeds/` folder
- [ ] Regenerated `hardware-configuration.nix`
- [ ] Added a wallpaper at `assets/wallpaper/1.png`
- [ ] Run `blur.sh` and `matugen/generate.sh`
- [ ] Set up mihomo `config.yaml` or removed the mihomo module
- [ ] Updated name, email, and SSH key in `git.nix`
- [ ] Checked display name, timezone, hostname
- [ ] Set `initialPassword`
- [ ] Replaced Chinese mirrors if you're outside China

---

## 🖥️ Tech Stack

| | |
|:---:|:---:|
| **WM** | [niri](https://github.com/YaLTeR/niri) — scrollable-tiling Wayland compositor |
| **Bar** | [waybar](https://github.com/Alexays/Waybar) — capsule-island style |
| **Launcher** | [fuzzel](https://codeberg.org/dnkl/fuzzel) — Wayland-native app launcher |
| **Terminal** | [kitty](https://sw.kovidgoyal.net/kitty/) — GPU-accelerated, cursor trail |
| **Shell** | [fish](https://fishshell.com) — vi mode, yazi integration |
| **Editor** | [neovim](https://neovim.io) — lazy.nvim, live-config symlink |
| **Notifications** | [swaync](https://github.com/ErikReider/SwayNotificationCenter) |
| **Lock Screen** | [hyprlock](https://github.com/hyprwm/hyprlock) — blurred screenshot |
| **Display Manager** | [greetd](https://sr.ht/~kennylevinsen/greetd/) + [tuigreet](https://github.com/apognu/tuigreet) |

---

## 🎨 Dynamic Theming

[matugen](https://github.com/InioX/matugen) extracts a color palette from your wallpaper and injects it into every app:

```
config/matugen/templates/   →   config/matugen/output/
├── kitty.conf                    # Terminal colors
├── waybar.css                    # Bar colors
├── fuzzel.ini                    # Launcher colors
├── mako.conf                     # Notification colors
├── hyprlock.conf                 # Lock screen colors
├── swaync.css / swayosd.css      # Notification center & OSD
└── gtk-colors.css / qt-colors.conf
```

Run `config/matugen/generate.sh` to regenerate all colors — running apps are **hot-reloaded** via signals.

> Color scheme: green-accented dark theme. Icons: `Papirus-Dark`. Cursor: `Bibata-Modern-Classic`. Font: `JetBrains Mono Nerd Font`.

---

## 📐 Niri: Vim-Style Scrolling Tiling

Unlike traditional tiling WMs, niri arranges windows as a **vertically scrolling paper roll**. Workspaces go left/right, windows go up/down.

| Keybind | Action |
|:--------|:-------|
| <kbd>Mod</kbd>+<kbd>h</kbd> / <kbd>l</kbd> | Left/right workspace |
| <kbd>Mod</kbd>+<kbd>j</kbd> / <kbd>k</kbd> | Down/up window |
| <kbd>Mod</kbd>+<kbd>Ctrl</kbd>+<kbd>h</kbd>/<kbd>l</kbd> | Move column left/right |
| <kbd>Mod</kbd>+<kbd>Ctrl</kbd>+<kbd>j</kbd>/<kbd>k</kbd> | Move window down/up |
| <kbd>Mod</kbd>+<kbd>1</kbd>–<kbd>9</kbd> | Switch to workspace N |

Blur, rounded corners, transparent unfocused windows ✨

---

## 🧱 Project Structure

```text
.
├── flake.nix                          # Entry point: NixOS + Home Manager
├── flake.lock
├── hosts/nixos/
│   ├── configuration.nix              # Minimal host config
│   └── hardware-configuration.nix
├── modules/
│   ├── system/                        # System-level NixOS modules
│   │   ├── boot.nix                   # systemd-boot, latest kernel
│   │   ├── desktop.nix                # niri, fonts, portals, bluetooth
│   │   ├── i18n.nix                   # Locale, fcitx5, rime-ice
│   │   ├── network.nix                # NetworkManager + mihomo proxy
│   │   ├── nix-settings.nix           # Flakes, mirrors, unfree
│   │   ├── packages.nix               # System-wide packages
│   │   ├── services.nix               # greetd, pipewire, flatpak, keyd
│   │   └── users.nix                  # User, fish, Firefox
│   └── home/shyweeds/                 # Home Manager user modules
│       ├── desktop/                   # fuzzel, hyprlock, mako, waybar ...
│       ├── shell.nix                  # fish + opencode
│       ├── terminal.nix               # kitty + fastfetch
│       ├── editors.nix                # neovim
│       ├── git.nix                    # git + lazygit (SSH signing)
│       ├── theming.nix                # GTK, Qt, cursor, dark mode
│       ├── battery-monitor.nix        # Custom systemd battery timer
│       └── packages.nix               # User packages
├── config/
│   ├── niri/config.kdl                # niri WM config
│   ├── waybar/                        # waybar bar + CSS
│   ├── matugen/                       # Templates + generator script
│   ├── fuzzel/fuzzel.ini
│   ├── nvim/init.lua                  # Neovim config (lazy.nvim)
│   └── mihomo/config.yaml             # Proxy rules
└── assets/wallpaper/
    ├── 1.png                          # Wallpaper
    ├── 1-blur.png                     # Pre-blurred (ImageMagick)
    └── blur.sh
```

---

## ✨ Highlights

- 🔄 **Reproducible** — one `nixos-rebuild switch` gets you the full setup
- 🚇 **Mihomo proxy** — TUN-mode VPN with split routing (CN direct, foreign proxied) + metacubexd dashboard
- 🔑 **keyd remapping** — auto-swaps Alt/Meta on external keyboards (macOS-style layout)
- 🔋 **Battery monitor** — systemd timer: notifies at ≤25%, hibernates at ≤15%
- ⌨️ **Chinese input** — fcitx5 + rime-ice, smooth CJK integration
- 🔗 **Live neovim config** — symlinked to `config/nvim/`, edit without rebuilding
- 🎣 **Fish shell** — yazi exits into cwd, vi mode, `btw` alias

---

<div align="center">

### 🛠️ Built with

<img src="https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white" />
<img src="https://img.shields.io/badge/Home_Manager-8BAAE4?style=for-the-badge&logo=nixos&logoColor=white" />
<img src="https://img.shields.io/badge/Wayland-FFBC00?style=for-the-badge&logo=wayland&logoColor=black" />
<img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" />

---

<sub>⭐ Star this repo if you find it useful!</sub>

</div>
