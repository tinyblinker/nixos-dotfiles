{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fuzzel
  ];
  xdg.configFile."fuzzel/fuzzel.ini".source = ../../../../config/fuzzel/fuzzel.ini;
}
