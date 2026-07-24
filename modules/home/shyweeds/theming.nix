{ config, pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };

  xdg.configFile."gtk-3.0/gtk.css".text = ''
    @import url("file://${config.home.homeDirectory}/.config/gtk-3.0/colors.css");
  '';
  xdg.configFile."gtk-4.0/gtk.css".text = ''
    @import url("file://${config.home.homeDirectory}/.config/gtk-4.0/colors.css");
  '';
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=${config.home.homeDirectory}/dotfiles/config/matugen/output/qt-colors.conf
    custom_palette=true
    icon_theme=Papirus-Dark
    style=Fusion
  '';
}
