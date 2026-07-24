{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    fuzzel
  ];
  xdg.configFile."fuzzel/fuzzel.ini".source = "${inputs.self}/config/fuzzel/fuzzel.ini";
}
