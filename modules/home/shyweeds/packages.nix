{ pkgs, ... }:
{
  home.packages = with pkgs; [
    firefox
    kdePackages.kdenlive
    yazi
    xwayland-satellite
    bat
    wlsunset
    btop
    upower
    nodejs
    brightnessctl
    pavucontrol
    playerctl
    bluez
    blueman
    cava
    obs-studio
    awww
    matugen
    qt6Packages.qt6ct
    adw-gtk3
    lxqt.lxqt-policykit
    libnotify
  ];
}
