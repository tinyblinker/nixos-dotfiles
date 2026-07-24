{
  inputs,
  config,
  pkgs,
  ...
}:
{
  # home.packages = [
  #   pkgs.neovim
  #   pkgs.vscode
  #   pkgs.emacs-pgtk
  #
  #   pkgs.gcc
  #   pkgs.fd
  #   pkgs.wl-clipboard
  #   pkgs.tree-sitter
  #   pkgs.ripgrep
  #   pkgs.gnumake
  #   pkgs.shellcheck
  #   pkgs.nil
  #   pkgs.nixfmt
  #   pkgs.nixd
  #   pkgs.lua-language-server
  #   pkgs.pyright
  #   pkgs.lua51Packages.luarocks
  #   pkgs.black
  #   pkgs.shellharden
  #   pkgs.stylua
  #   pkgs.lua5_1
  #   pkgs.deadnix
  #   pkgs.ruff
  #   pkgs.bash-language-server
  # ];
  #
  # home.sessionVariables = {
  #   EDITOR = "nvim";
  # };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${inputs.self}/config/nvim";
  xdg.configFile."emacs".source = config.lib.file.mkOutOfStoreSymlink "${inputs.self}/config/emacs";
}
