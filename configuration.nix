{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  # HiDPI 屏下放大 systemd-boot 菜单字体:80x25 标准文本模式
  boot.loader.systemd-boot.consoleMode = "0";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
    ];
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  # TTY 控制台字体:屏幕 2560x1600(~191 DPI),用 Terminus 32px 高分屏字体
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
  services.keyd = {
    enable = true;
    keyboards = {
      externalKeyboard = {
        ids = [ "3554:fa09" ];
        settings = {
          main = {
            leftalt = "leftmeta";
            leftmeta = "leftalt";
          };
        };
      };
    };
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # 参考 ryan4yin/nix-config:最简 tuigreet,用 $HOME/.wayland-session 间接层启动会话
        user = "shyweeds";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session";
      };
    };
  };
  programs.niri.enable = true;
  # xdg-desktop-portal:屏幕捕获/文件对话框/配色方案等桌面集成
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk # GTK 文件选择器
      pkgs.xdg-desktop-portal-wlr # wlroots 屏幕捕获(niri 兼容)
    ];
  };
  # hyprlock 锁屏 PAM 服务
  security.pam.services.hyprlock = { };
  programs.dconf.enable = true; # dconf 支持(home-manager 的 color-scheme=prefer-dark 依赖它)
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.power-profiles-daemon.enable = true;
  services.mihomo = {
    enable = true;
    tunMode = true;
    processesInfo = true;
    configFile = "/home/shyweeds/dotfiles/mihomo/config.yaml";
    webui = pkgs.metacubexd;
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  services.libinput.enable = true;
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
  hardware.graphics.enable = true;
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    networkmanagerapplet
  ];
  networking.firewall = {
    enable = true;
    trustedInterfaces = [
      "Meta"
      "Mihomo"
    ];
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
    "https://mirrors.bfsu.edu.cn/nix-channels/store"
    "https://mirrors.nju.edu.cn/nix-channels/store"
    "https://mirrors.iscas.ac.cn/nix-channels/store"
  ];
  # do not edit it anyway, this may mismatch the system edition, it's common
  system.stateVersion = "26.11";
}
