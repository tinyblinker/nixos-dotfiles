{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # base-utils
    gdb
    lldb
    clang-tools # llvm-full without llvm
    yazi
    bat
    wlsunset
    btop
    upower
    nodejs
    fd
    brightnessctl
    vscode
    wl-clipboard
    pavucontrol
    playerctl
    bluez
    blueman
    cava
    obs-studio
    rustup
    waybar
    fuzzel
    awww
    swayosd
    hyprlock
    swayidle
    matugen
    qt6Packages.qt6ct
    adw-gtk3
    lxqt.lxqt-policykit
    libnotify
  ];
}
