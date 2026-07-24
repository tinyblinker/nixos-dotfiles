{ config, pkgs, ... }:
{
  # home.packages = with pkgs; [
  #   fuzzel
  # ];
  programs.fuzzel = {
    enable = true;
    settings = "${config.home.homeDirectory}/dotfiles/config/fuzzel/fuzzel.ini";
  };
  programs.fzf.enable = true;
  # xdg.configFile."fuzzel/fuzzel.ini".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/fuzzel/fuzzel.ini";
}
