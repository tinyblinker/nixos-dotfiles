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
    pavucontrol
    playerctl
    bluez
    blueman
    cava
    obs-studio
    qt6Packages.qt6ct
    adw-gtk3
  ];
}
