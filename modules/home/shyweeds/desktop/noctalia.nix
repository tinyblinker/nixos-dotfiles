{ inputs, config, lib, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    package = lib.mkDefault inputs.noctalia.packages.x86_64-linux.default;

    settings = {
      shell.font = "JetBrainsMono Nerd Font";

      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper.path = "${config.home.homeDirectory}/dotfiles/assets/wallpaper/1.png";
      };

      wallpaper = {
        enabled = true;
        default.path = "${config.home.homeDirectory}/dotfiles/assets/wallpaper/1.png";
      };

      bar.bar-1 = {
        position = "top";
        widgets = {
          left = [ "workspaces" "tray" ];
          center = [ "clock" "window-title" ];
          right = [ "battery" "bluetooth" "network" "system-monitor" "backlight" "audio" "audio-mic" ];
        };
      };
    };
  };
}
