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
    swaybg
    brightnessctl
    wl-clipboard
    pavucontrol
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
  # niri 配置(可滚动平铺 Wayland 合成器),config.kdl 保存即热重载
  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
  xdg.configFile."wofi/style.css".source = ./wofi/style.css;
  programs.wofi.enable = true;
}
