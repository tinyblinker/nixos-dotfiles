{
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      width = 400;
      height = 150;
      margin = "10";
      padding = "10";
      border-radius = 12;
      border-size = 2;
      default-timeout = 10000;
    };
    extraConfig = ''
      include=/home/shyweeds/dotfiles/config/matugen/output/mako.conf
    '';
  };
}
