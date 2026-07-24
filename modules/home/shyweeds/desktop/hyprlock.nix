{ config, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 0;
        ignore_empty_input = true;
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 10;
        }
      ];
      label = [
        {
          text = "$TIME";
          color = "$on_surface";
          font_size = 72;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {
          placeholder_text = "password …";
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];
    };
    extraConfig = "source = ${config.home.homeDirectory}/dotfiles/config/matugen/output/hyprlock.conf";
  };
}
