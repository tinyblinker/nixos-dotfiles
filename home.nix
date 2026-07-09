{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  # catppuccin 全局主题(参考 ryan4yin):自动给 kitty/gtk/fastfetch 等上色
  imports = [ inputs.catppuccin.homeModules.catppuccin ];
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "pink";
    # fcitx5 用自带输入法皮肤,交给它自己(避免与 rime 皮肤冲突)
    fcitx5.enable = false;
  };

  home.username = "shyweeds";
  home.homeDirectory = "/home/shyweeds";
  home.stateVersion = "26.05";

  # GTK 主题与图标交给 catppuccin.gtk;这里只保留 enable
  gtk = {
    enable = true;
  };
  # libadwaita(GTK4)/xdg-portal 通过此项判定深浅色,是"全局深色"的关键
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true; # 应用到 GTK
    x11.enable = true; # 应用到 XWayland 应用
  };

  programs.opencode.enable = true;
  # shell configs
  programs.bash.enable = true;
  programs.fish = {
    enable = true;
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
    # noctalia-shell:桌面 shell(状态栏/启动器/通知/锁屏/OSD 等)
    noctalia-shell
    qt6Packages.qt6ct
    app2unit
    cliphist
  ];
  programs.lazygit = {
    enable = true;
    settings.git.autoFetch = false;
  };
  # helix 编辑器(配置文件在 ./helix/)
  programs.helix = {
    enable = true;
    defaultEditor = true;
    # LSP / 格式化器(helix 按 PATH 里的二进制名自动识别)
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
  # 主题由 config.toml 里直接设置 theme = "catppuccin_mocha"
  catppuccin.helix.enable = false;
  # fastfetch:精致简约,配绿色主题
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
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
  # niri 配置(可滚动平铺 Wayland 合成器),config.kdl 保存即热重载
  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
  # rime 配置:启用雾凇拼音(其余设置沿用雾凇合理默认,无需多写)
  xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
    patch:
      schema_list:
        - schema: rime_ice      # 雾凇拼音
      menu/page_size: 8         # 候选词每页显示 8 个
  '';

  # 强制默认简体(否则雾凇会记住上次状态,可能停在繁体)。
  # 覆盖 switches 会整体替换,故需列全雾凇原有开关,只在简繁上加 reset:0。
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

  # fcitx5 候选框:仅设字体,主题用默认(不再用绿色 GreenDark,避免与 catppuccin 冲突)
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Font="Noto Sans CJK SC 13"
    PerScreenDPI=True
  '';

  # greetd 通过 $HOME/.wayland-session 启动会话的间接层(参考 ryan4yin/nix-config):
  # 好处是切换合成器时无需改 greetd 配置,只改这个脚本即可。
  home.file.".wayland-session" = {
    source = pkgs.writeScript "init-session" ''
      # 先停掉可能残留的上一个 niri 会话
      systemctl --user is-active niri.service && systemctl --user stop niri.service
      # 再启动新的
      /run/current-system/sw/bin/niri-session
    '';
    executable = true;
  };

  # noctalia-shell 的 Qt 配置(参考 ryan4yin)
  home.sessionVariables = {
    "QT_QPA_PLATFORM" = "wayland;xcb";
    "QT_QPA_PLATFORMTHEME" = "qt6ct";
    "QT_AUTO_SCREEN_SCALE_FACTOR" = "1";
  };
  # noctalia 配置目录用 out-of-store 软链,便于 noctalia 运行时读写自身设置
  xdg.configFile."noctalia".source =
    config.lib.file.mkOutOfStoreSymlink "/home/shyweeds/dotfiles/noctalia/config";
  xdg.configFile."qt6ct/qt6ct.conf".source =
    config.lib.file.mkOutOfStoreSymlink "/home/shyweeds/dotfiles/noctalia/qt6ct.conf";

  # 空闲策略:300s 熄屏(视频播放时因空闲抑制不熄屏),再 100s(共 400s)锁屏并休眠。
  # 锁屏改用 noctalia(swaylock 已移除)。
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.noctalia-shell}/bin/noctalia-shell ipc call lockScreen lock";
      lock = "${pkgs.noctalia-shell}/bin/noctalia-shell ipc call lockScreen lock";
    };
    timeouts = [
      {
        # 300s 无操作:DPMS 熄屏;有输入时自动亮屏
        timeout = 300;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      {
        # 再过 100s(共 400s):进入休眠(休眠前 before-sleep 会先锁屏)
        timeout = 400;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
}
