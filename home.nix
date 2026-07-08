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
  home.sessionVariables.EDITOR = "nvim";
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
    btop
    upower
    nodejs
    fastfetch
    fd
    brightnessctl
    wl-clipboard
    pavucontrol
    playerctl
    swaylock
    bluez-tools
    awww
  ];
  programs.lazygit = {
    enable = true;
    settings.git.autoFetch = false;
  };
  # neovim 由 nixCats 管理(插件用 nix 装,配置用 lua 写)
  nvim = {
    enable = true;
    packageNames = [ "nvim" ];
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

  # fcitx5 候选框皮肤:自定义深色绿主题(呼应 niri 的 #5C8374/#0d1117)
  xdg.dataFile."fcitx5/themes/GreenDark/theme.conf".text = ''
    [Metadata]
    Name=GreenDark
    Version=1.0
    Author=custom
    Description=Dark green theme
    ScaleWithDPI=True

    [InputPanel]
    NormalColor=#c9d1d9              # 普通候选词文字(浅灰)
    HighlightCandidateColor=#0d1117  # 选中候选词文字(深色,压在绿底上)
    HighlightColor=#93B1A6           # 编码区高亮文字(浅绿)
    PageButtonAlignment=Last Candidate

    [InputPanel/TextMargin]
    Left=8
    Right=8
    Top=6
    Bottom=6

    [InputPanel/ContentMargin]
    Left=4
    Right=4
    Top=4
    Bottom=4

    [InputPanel/Background]
    Color=#0d1117                    # 候选框底色(深)
    BorderColor=#5C8374              # 边框(绿)
    BorderWidth=1

    [InputPanel/Background/Margin]
    Left=3
    Right=3
    Top=3
    Bottom=3

    [InputPanel/Highlight]
    Color=#5C8374                    # 选中候选词的底色(绿)

    [InputPanel/Highlight/Margin]
    Left=6
    Right=6
    Top=5
    Bottom=5

    [Menu]
    NormalColor=#c9d1d9
    HighlightColor=#0d1117

    [Menu/Background]
    Color=#0d1117
    BorderColor=#5C8374
    BorderWidth=1

    [Menu/Background/Margin]
    Left=2
    Right=2
    Top=2
    Bottom=2

    [Menu/ContentMargin]
    Left=2
    Right=2
    Top=2
    Bottom=2

    [Menu/Highlight]
    Color=#5C8374

    [Menu/Highlight/Margin]
    Left=5
    Right=5
    Top=5
    Bottom=5

    [Menu/Separator]
    Color=#30363d

    [Menu/TextMargin]
    Left=5
    Right=5
    Top=5
    Bottom=5
  '';

  # 选用上面的皮肤 + 字体
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Theme=GreenDark
    Font="Noto Sans CJK SC 13"
    PerScreenDPI=True
  '';

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
  xdg.configFile."wofi/style.css".source = ./wofi/style.css;
  programs.wofi.enable = true;
  # 通知守护进程
  services.mako.enable = true;
  # 空闲自动锁屏 / 休眠前锁屏
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
      lock = "${pkgs.swaylock}/bin/swaylock -f";
    };
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
  };
}
