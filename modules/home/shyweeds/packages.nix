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
    nodejs
    pavucontrol
    playerctl
    blueman
    cava
    obs-studio
    qt6Packages.qt6ct
    adw-gtk3
    networkmanagerapplet
  ];
}
