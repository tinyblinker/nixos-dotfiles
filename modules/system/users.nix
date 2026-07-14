{ pkgs, ... }:
{
  users.users.shyweeds = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      tree
    ];
  };
  programs.firefox = {
    enable = true;
  };
  programs.fish.enable = true;
}
