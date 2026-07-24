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
  programs.fish.enable = true;
}
