{ pkgs, ... }:
{
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "ter-v32n";
    packages = [ pkgs.terminus_font ];
    keyMap = "us";
  };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        (fcitx5-rime.override {
          rimeDataPkgs = [
            rime-ice
            rime-data
          ];
        })
        kdePackages.fcitx5-qt
        qt6Packages.fcitx5-configtool
        fcitx5-gtk
      ];
    };
  };
}
