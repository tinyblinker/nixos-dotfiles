{ config, pkgs, lib, inputs, ... }:

{
  home.username = "shyweeds";
  home.homeDirectory = "/home/shyweeds";
  home.stateVersion = "26.05";
  programs.opencode.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };
  programs.git = {
    enable = true;
    userName = "tinyblinker";
    userEmail = "2149934895@qq.com";
  };
  home.packages = with pkgs; [
    neovim
    ripgrep 
    yazi
    bat
    nixd
    nil
    nixfmt
    nodejs
    gcc
    gdb
    fastfetch
    lazygit
  ];
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.8";
    };
  };
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "wofi --show run";
      keybindings = lib.mkOptionDefault {
          "${modifier}+Shift+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          # 使用修饰键+Shift+c 重新加载配置
          "${modifier}+Shift+c" = "reload";
      };
    };
  };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
  programs.wofi.enable = true;
}
