{ config, lib, ... }:
{
  services.swaync = {
    enable = true;
    style = null;
  };

  xdg.configFile."swaync/style.css" = lib.mkForce {
    enable = false;
  };

  home.file.".config/swaync/style.css".source =
    config.lib.file.mkOutOfStoreSymlink
      "/home/shyweeds/dotfiles/config/matugen/output/swaync.css";

  xdg.configFile."swaync/config.json".source =
    lib.mkForce ../../../../config/swaync/config.json;
}
