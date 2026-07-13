{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  home.username = "shyweeds";
  home.homeDirectory = "/home/shyweeds";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    ripgrep
    gnumake
    shellcheck
    yazi
    bat
    tree-sitter
    wlsunset
    btop
    upower
    nodejs
    fd
    brightnessctl
    vscode
    wl-clipboard
    pavucontrol
    playerctl
    bluez
    blueman
    cava
    neovim
    gcc
    gdb
    lldb
    clang-tools
    nil
    nixfmt
    nixd
    lua-language-server
    pyright
    lua51Packages.luarocks
    black
    shellharden
    obs-studio
    stylua
    rustup
    lua5_1
    deadnix
    ruff
    bash-language-server
    marksman
    taplo
    yaml-language-server
    vscode-langservers-extracted
    # 桌面组件
    waybar
    fuzzel
    awww
    # OSD(音量/亮度/CapsLock 指示) + 通知中心(保留历史)
    swayosd
    swaynotificationcenter
    # 锁屏 + 空闲 + 配色
    hyprlock
    swayidle
    matugen
    # matugen 全局配色依赖
    qt6Packages.qt6ct
    adw-gtk3
    # polkit 认证代理(GUI 密码弹窗)
    lxqt.lxqt-policykit
    libnotify
  ];

  # ---- GTK / 光标 / 图标(主题不变) ----
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark"; # GTK 骨架,皮肤由 matugen colors.css 提供
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # ---- shell / 编辑器 / git ----
  programs.opencode.enable = true;
  programs.bash.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = "fish_vi_key_bindings"; # vim 模式
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
    functions = {
      y = ''
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        command yazi $argv --cwd-file="$tmp"
        if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
          builtin cd -- "$cwd"
        end
        command rm -f -- "$tmp"
      '';
    };
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "tinyblinker";
      user.email = "2149934895@qq.com";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };
  programs.lazygit = {
    enable = true;
    settings.git.autoFetch = false;
  };

  # ---- neovim ----
  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.QT_QPA_PLATFORM = "wayland";
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct"; # Qt 配色由 qt6ct 接管
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/shyweeds/dotfiles/nvim";
  # ---- fastfetch ----
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        padding = {
          top = 1;
          left = 2;
          right = 4;
        };
        color = {
          "1" = "38;2;92;131;116";
          "2" = "38;2;147;177;166";
        };
      };
      display = {
        separator = "  ";
        color.keys = "38;2;147;177;166";
      };
      modules = [
        "break"
        {
          type = "title";
          color = {
            user = "38;2;92;131;116";
            host = "38;2;147;177;166";
          };
        }
        {
          type = "separator";
          string = "─";
          length = 26;
        }
        {
          type = "os";
          key = "  OS";
          keyColor = "green";
        }
        {
          type = "kernel";
          key = "  Kernel";
          keyColor = "green";
        }
        {
          type = "uptime";
          key = "  Uptime";
          keyColor = "green";
        }
        {
          type = "packages";
          key = "  Pkgs";
          keyColor = "green";
        }
        {
          type = "shell";
          key = "  Shell";
          keyColor = "green";
        }
        {
          type = "wm";
          key = "  WM";
          keyColor = "green";
        }
        {
          type = "terminal";
          key = "  Term";
          keyColor = "green";
        }
        "break"
        {
          type = "cpu";
          key = "  CPU";
          keyColor = "cyan";
        }
        {
          type = "gpu";
          key = "  GPU";
          keyColor = "cyan";
        }
        {
          type = "memory";
          key = "  RAM";
          keyColor = "cyan";
        }
        {
          type = "disk";
          key = "  Disk";
          keyColor = "cyan";
        }
        "break"
        {
          type = "colors";
          symbol = "circle";
          paddingLeft = 2;
        }
        "break"
      ];
    };
  };

  # ---- kitty ----
  programs.kitty = {
    enable = true;
    # 引用 matugen 生成的颜色
    extraConfig = "include /home/shyweeds/dotfiles/matugen/output/kitty.conf";
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = "18";
      cursor_trail = "3";
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = "2";
      background_opacity = 0.8;
    };
    keybindings = {
      "ctrl+shift+enter" = "no_op";
      "ctrl+shift+w" = "no_op";
      "ctrl+shift+q" = "no_op";
    };
  };

  # ---- niri 配置 ----
  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

  # ---- rime 输入法 ----
  xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
    patch:
      schema_list:
        - schema: rime_ice
      menu/page_size: 8
  '';
  xdg.dataFile."fcitx5/rime/rime_ice.custom.yaml".text = ''
    patch:
      switches:
        - { name: ascii_mode, reset: 0, states: [ 中, Ａ ] }
        - { name: ascii_punct, reset: 0, states: [ ¥, $ ] }
        - { name: traditionalization, reset: 0, states: [ 简, 繁 ] }
        - { name: emoji, reset: 1, states: [ 💀, 😄 ] }
        - { name: full_shape, reset: 0, states: [ 半角, 全角 ] }
        - { name: search_single_char, states: [ 正常, 单字 ], abbrev: [ 词, 单 ] }
  '';
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Font="Noto Sans CJK SC 13"
    PerScreenDPI=True
  '';

  # ---- greetd 间接启动脚本 ----
  home.file.".wayland-session" = {
    source = pkgs.writeScript "init-session" ''
      systemctl --user is-active niri.service && systemctl --user stop niri.service
      /run/current-system/sw/bin/niri-session
    '';
    executable = true;
  };

  # ---- 桌面组件配置(颜色统一引用 matugen/output/) ----

  # waybar:状态栏,样式导入 matugen 颜色
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  # fuzzel:启动器,颜色由 matugen 生成后 include
  xdg.configFile."fuzzel/fuzzel.ini".source = ./fuzzel/fuzzel.ini;

  # GTK 桥接 CSS:将 matugen 生成的 colors.css 注入 GTK3/GTK4
  xdg.configFile."gtk-3.0/gtk.css".text = ''
    @import url("file:///home/shyweeds/.config/gtk-3.0/colors.css");
  '';
  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @import url("file:///home/shyweeds/.config/gtk-4.0/colors.css");
  '';
  # Qt 配色:qt6ct 指向 matugen 生成的调色板
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=/home/shyweeds/dotfiles/matugen/output/qt-colors.conf
    custom_palette=true
    icon_theme=Papirus-Dark
    style=Fusion
  '';

  # mako:通知守护进程(配置直接内联,无 configFile 选项)
  # mako:通知守护进程。颜色由 matugen 生成,通过 mako include 引入
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      width = 400;
      height = 150;
      margin = "10";
      padding = "10";
      border-radius = 12;
      border-size = 2;
      default-timeout = 10000;
    };
    extraConfig = ''
      include=/home/shyweeds/dotfiles/matugen/output/mako.conf
    '';
  };

  # swaync:通知中心(保留历史),样式由 matugen 生成
  services.swaync = {
    enable = true;
    style = "/home/shyweeds/dotfiles/matugen/output/swaync.css";
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-margin-top = 8;
      control-center-margin-bottom = 8;
      control-center-margin-right = 8;
      control-center-margin-left = 8;
      control-center-height = 600;
      control-center-width = 400;
      timeout = 10;
      timeout-low = 7;
      timeout-critical = 0;
      fit-to-screen = true;
      image-visibility = "when-available";
      notification-window-width = 400;
      keyboard-shortcuts = true;
    };
  };

  # swayosd:亮度/音量/CapsLock OSD,样式由 matugen 生成
  services.swayosd = {
    enable = true;
    stylePath = "/home/shyweeds/dotfiles/matugen/output/swayosd.css";
  };

  # hyprlock:锁屏。配色变量由 matugen 生成到 hyprlock.conf(source 引用)
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 0;
        ignore_empty_input = true;
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 10;
        }
      ];
      label = [
        {
          text = "$TIME";
          color = "$on_surface";
          font_size = 72;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {
          placeholder_text = "password …";
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];
    };
    extraConfig = "source = /home/shyweeds/dotfiles/matugen/output/hyprlock.conf";
  };

  # swayidle:空闲管理
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.hyprlock}/bin/hyprlock";
      lock = "${pkgs.hyprlock}/bin/hyprlock";
    };
    timeouts = [
      {
        timeout = 300;
        command = "${lib.getExe pkgs.niri} msg action power-off-monitors";
        resumeCommand = "${lib.getExe pkgs.niri} msg action power-on-monitors";
      }
      {
        timeout = 400;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  # 低电量监控:每分钟检查,≤25% 通知,≤15% 休眠/挂起
  systemd.user.services.battery-monitor = {
    Unit = {
      Description = "Battery monitor";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "battery-monitor" ''
        BATTERY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
        STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
        HIBERNATE_FLAG="/tmp/battery-monitor-hibernated"

        if [ -z "$BATTERY" ]; then
          exit 0
        fi

        if [ "$STATUS" != "Discharging" ]; then
          exit 0
        fi

        if [ "$BATTERY" -le 15 ]; then
          if [ -f "$HIBERNATE_FLAG" ]; then
            ${pkgs.libnotify}/bin/notify-send \
              -u critical \
              "Battery Low" \
              "Battery is at $BATTERY%. Please charge your device."
            exit 0
          fi
          touch "$HIBERNATE_FLAG"
          ${pkgs.systemd}/bin/systemctl hibernate || ${pkgs.systemd}/bin/systemctl suspend
          exit 0
        fi

        if [ "$BATTERY" -le 25 ]; then
          ${pkgs.libnotify}/bin/notify-send \
            -u critical \
            "Battery Low" \
            "Battery is at $BATTERY%. Please charge your device."
        fi

        rm -f "$HIBERNATE_FLAG"
      ''}";
    };
  };

  systemd.user.timers.battery-monitor = {
    Unit.Description = "Battery monitor timer";
    Timer = {
      OnCalendar = "minutely";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
