{ config, pkgs, lib, inputs, ... }:

{
  home.username = "shyweeds";
  home.homeDirectory = "/home/shyweeds";
  home.stateVersion = "26.05";
  programs.opencode.enable = true;
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
    };
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
      modifier = "Mod1";
      terminal = "kitty";
      menu = "wofi --show drun";
      keybindings = lib.mkOptionDefault {
          "${modifier}+Shift+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          # 使用修饰键+Shift+c 重新加载配置
          "${modifier}+Shift+c" = "reload";
      };
      bars = [];
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
