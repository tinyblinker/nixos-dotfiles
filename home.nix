{ config, pkgs, lib, inputs, ... }:

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
      background_opacity = "0.8";
      font_family = "JetBrainsMono Nerd Font";
      font_size = "16";
    };
  };
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod1";
      terminal = "kitty";
      menu = "wofi --show drun";
      output = {
        "*" = {
          scale = "1.6";
          bg = "${./wallpaper/1.png} fill";
        };
      };
      window = {
        titlebar = false;
        border = 4;
      };
      keybindings = lib.mkOptionDefault {
          "${modifier}+Shift+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          # 使用修饰键+Shift+c 重新加载配置
          "${modifier}+Shift+c" = "reload";
      };
      bars = [];
      startup = [
        { command = "${pkgs.fcitx5}/bin/fcitx5 -d"; }
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; }
      ];
    };
  };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
  xdg.configFile."wofi/style.css".source = ./wofi/style.css;
  programs.wofi.enable = true;
}
