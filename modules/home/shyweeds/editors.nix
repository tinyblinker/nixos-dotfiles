{ config, ... }:
{
  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.QT_QPA_PLATFORM = "wayland";
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/shyweeds/dotfiles/config/nvim";
}
