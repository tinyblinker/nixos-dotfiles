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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
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
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${inputs.self}/config/nvim";
  xdg.configFile."emacs".source = config.lib.file.mkOutOfStoreSymlink "${inputs.self}/config/emacs";
}
