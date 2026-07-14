{ pkgs, lib, ... }:
{
  systemd.user.services.battery-monitor = {
    Unit = {
      Description = "Battery monitor";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "battery-monitor" ''
        BATTERY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
        STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
        HIBERNATE_FLAG="/tmp/battery-monitor-hibernated"

        if [ -z "$BATTERY" ]; then
          exit 0
        fi

        if [ "$STATUS" != "Discharging" ]; then
          exit 0
        fi

        if [ "$BATTERY" -le 15 ]; then
          if [ -f "$HIBERNATE_FLAG" ]; then
            ${pkgs.libnotify}/bin/notify-send \
              -u critical \
              "Battery Low" \
              "Battery is at $BATTERY%. Please charge your device."
            exit 0
          fi
          touch "$HIBERNATE_FLAG"
          ${pkgs.systemd}/bin/systemctl hibernate || ${pkgs.systemd}/bin/systemctl suspend
          exit 0
        fi

        if [ "$BATTERY" -le 25 ]; then
          ${pkgs.libnotify}/bin/notify-send \
            -u critical \
            "Battery Low" \
            "Battery is at $BATTERY%. Please charge your device."
        fi

        rm -f "$HIBERNATE_FLAG"
      ''}";
    };
  };

  systemd.user.timers.battery-monitor = {
    Unit.Description = "Battery monitor timer";
    Timer = {
      OnCalendar = "minutely";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
