{ pkgs, ... }:
{
  home.file.".wayland-session" = {
    source = pkgs.writeScript "init-session" ''
      systemctl --user is-active niri.service && systemctl --user stop niri.service
      /run/current-system/sw/bin/niri-session
    '';
    executable = true;
  };
}
