{ config, ... }:
{
  services.swayosd = {
    enable = true;
    stylePath = "${config.home.homeDirectory}/dotfiles/config/matugen/output/swayosd.css";
  };
}
