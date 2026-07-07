{ config, lib, pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ 
      qt6Packages.fcitx5-chinese-addons 
      qt6Packages.fcitx5-configtool
      fcitx5-gtk 
    ];
  };
  services.xserver.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --remember --asterisks --cmd sway --theme 'border=#5C8374;text=#93B1A6;prompt=#5C8374;title=#93B1A6;input=#93B1A6;container=#0d1117;greet=#5C8374'";
        user = "greeter";
      };
    };
  };
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  services.mihomo = {
     enable = true;
     tunMode = true;
     processesInfo = true;
     configFile = ./mihomo/config.yaml;
     webui = pkgs.metacubexd;  
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.libinput.enable = true;
  users.users.shyweeds = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      tree
    ];
  };
  programs.firefox = {
    enable = true;
  };
  programs.fish.enable = true;
  hardware.graphics.enable = true;
  environment.systemPackages = with pkgs; [
    git
    vim 
    wget
  ];
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "Meta" "Mihomo" ];
    checkReversePath = "loose";
  };
  networking.networkmanager.wifi.powersave = false;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
  nix.settings.substituters = [
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://mirrors.cernet.edu.cn/nix-channels/store"
    "https://mirrors.sjtu.edu.cn/nix-channels/store"
    "https://mirrors.bfsu.edu.cn/nix-channels/store"
    "https://mirrors.nju.edu.cn/nix-channels/store"
    "https://mirrors.iscas.ac.cn/nix-channels/store"
  ];
  # do not edit it anyway, this may mismatch the system edition, it's common
  system.stateVersion = "26.11";
}
