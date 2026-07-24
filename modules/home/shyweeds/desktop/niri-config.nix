{ inputs, ... }:
{
  xdg.configFile."niri/config.kdl".source = "${inputs.self}/config/niri/config.kdl";
}
