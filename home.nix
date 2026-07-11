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
    yazi
    bat
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
    bluez-tools
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
  ];

  # ---- GTK / 光标 / 图标(主题不变) ----
  gtk = {
    enable = true;
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
    shellAliases = { btw = "echo i use nixos, btw"; };
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

  # ---- helix 编辑器 ----
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      nil nixfmt-rfc-style
      lua-language-server
      pyright ruff
      rust-analyzer
      bash-language-server
      marksman taplo
      yaml-language-server
      vscode-langservers-extracted
      clang-tools
    ];
  };
  xdg.configFile."helix/config.toml".source = ./helix/config.toml;
  xdg.configFile."helix/languages.toml".source = ./helix/languages.toml;

  # ---- fastfetch ----
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = { top = 1; left = 2; right = 4; };
        color = { "1" = "38;2;92;131;116"; "2" = "38;2;147;177;166"; };
      };
      display = {
        separator = "  ";
        color.keys = "38;2;147;177;166";
      };
      modules = [
        "break"
        { type = "title"; color = { user = "38;2;92;131;116"; host = "38;2;147;177;166"; }; }
        { type = "separator"; string = "─"; length = 26; }
        { type = "os"; key = "  OS"; keyColor = "green"; }
        { type = "kernel"; key = "  Kernel"; keyColor = "green"; }
        { type = "uptime"; key = "  Uptime"; keyColor = "green"; }
        { type = "packages"; key = "  Pkgs"; keyColor = "green"; }
        { type = "shell"; key = "  Shell"; keyColor = "green"; }
        { type = "wm"; key = "  WM"; keyColor = "green"; }
        { type = "terminal"; key = "  Term"; keyColor = "green"; }
        "break"
        { type = "cpu"; key = "  CPU"; keyColor = "cyan"; }
        { type = "gpu"; key = "  GPU"; keyColor = "cyan"; }
        { type = "memory"; key = "  RAM"; keyColor = "cyan"; }
        { type = "disk"; key = "  Disk"; keyColor = "cyan"; }
        "break"
        { type = "colors"; symbol = "circle"; paddingLeft = 2; }
        "break"
      ];
    };
  };

  # ---- kitty ----
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = "18";
      cursor_trail = "3";
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = "2";
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

  # mako:通知守护进程(配置直接内联,无 configFile 选项)
  services.mako = {
    enable = true;
    backgroundColor = "#0d1117";
    textColor = "#c9d1d9";
    borderColor = "#5C8374";
    progressColor = "source over #5C8374";
    defaultTimeout = 10000;
    anchor = "top-right";
    width = 400;
    height = 150;
    margin = "10";
    padding = "10";
    borderRadius = 12;
    borderSize = 2;
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

  # hyprlock:锁屏,配置由 matugen 生成
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
          color = "$textColor";
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
}
