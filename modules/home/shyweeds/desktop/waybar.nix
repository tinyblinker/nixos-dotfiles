{ self, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  xdg.configFile."waybar/config".source =
    "${self}/config/waybar/config";
  xdg.configFile."waybar/style.css".source =
    "${self}/config/waybar/style.css";
}
