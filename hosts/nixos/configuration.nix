{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/default.nix
  ];

  networking.hostName = "nixos";
  system.stateVersion = "26.11";
}
