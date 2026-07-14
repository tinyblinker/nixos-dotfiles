{ pkgs, lib, ... }:
{
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.hyprlock}/bin/hyprlock";
      lock = "${pkgs.hyprlock}/bin/hyprlock";
    };
    timeouts = [
      {
        timeout = 300;
        command = "${lib.getExe pkgs.niri} msg action power-off-monitors";
        resumeCommand = "${lib.getExe pkgs.niri} msg action power-on-monitors";
      }
      {
        timeout = 400;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
}
