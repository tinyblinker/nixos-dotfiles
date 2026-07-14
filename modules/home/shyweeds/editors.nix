{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
    vscode

    # Neovim depends
    gcc
    fd
    wl-clipboard
    tree-sitter
    ripgrep
    gnumake
    shellcheck
    nil
    nixfmt
    nixd
    lua-language-server
    pyright
    lua51Packages.luarocks
    black
    shellharden
    stylua
    lua5_1
    deadnix
    ruff
    bash-language-server
  ];
  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.QT_QPA_PLATFORM = "wayland";
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "/home/shyweeds/dotfiles/config/nvim";
}
