{ pkgs, nixpkgs-unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
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
    package = nixpkgs-unstable.legacyPackages.x86_64-linux.mihomo;
    tunMode = true;
    processesInfo = true;
    configFile = "/home/shyweeds/dotfiles/config/mihomo/config.yaml";
    webui = pkgs.metacubexd;
  };
}
