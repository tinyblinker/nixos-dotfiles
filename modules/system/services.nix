{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "shyweeds";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session";
      };
    };
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.flatpak.enable = true;
  services.power-profiles-daemon.enable = true;
  services.keyd = {
    enable = true;
    keyboards = {
      externalKeyboard = {
        ids = [ "3554:fa09" ];
        settings = {
          main = {
            leftalt = "layer(meta)";
            leftmeta = "layer(alt)";
          };
        };
      };
    };
  };
}
