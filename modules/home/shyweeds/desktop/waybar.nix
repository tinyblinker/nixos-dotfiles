{ config, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  xdg.configFile."waybar/config".source =
    "${config.home.homeDirectory}/dotfiles/config/waybar/config";
  xdg.configFile."waybar/style.css".source =
    "${config.home.homeDirectory}/dotfiles/config/waybar/style.css";
}
