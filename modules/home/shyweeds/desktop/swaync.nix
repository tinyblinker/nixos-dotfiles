{ lib, ... }:
{
  services.swaync = {
    enable = true;
    style = "/home/shyweeds/dotfiles/config/matugen/output/swaync.css";
  };

  xdg.configFile."swaync/config.json".source =
    lib.mkForce ../../../../config/swaync/config.json;
}
