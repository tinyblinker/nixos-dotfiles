{ config, pkgs, nixpkgs-unstable, ... }:
{
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [
      "Meta"
      "Mihomo"
    ];
    checkReversePath = "loose";
  };
  services.mihomo = {
    enable = true;
    package = nixpkgs-unstable.legacyPackages.${pkgs.system}.mihomo;
    tunMode = true;
    processesInfo = true;
    configFile = "${config.users.users.shyweeds.home}/dotfiles/config/mihomo/config.yaml";
    webui = pkgs.metacubexd;
  };
}
