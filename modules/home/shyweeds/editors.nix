{
  config,
  pkgs,
  lib,
  ...
}:
let
  neovim-deps = [
    pkgs.gcc
    pkgs.fd
    pkgs.wl-clipboard
    pkgs.tree-sitter
    pkgs.ripgrep
    pkgs.gnumake
    pkgs.shellcheck
    pkgs.nil
    pkgs.nixfmt
    pkgs.nixd
    pkgs.lua-language-server
    pkgs.pyright
    pkgs.lua51Packages.luarocks
    pkgs.black
    pkgs.shellharden
    pkgs.stylua
    pkgs.lua5_1
    pkgs.deadnix
    pkgs.ruff
    pkgs.bash-language-server
  ];

  neovim-wrapped = pkgs.symlinkJoin {
    name = "neovim-with-deps";
    paths = [ pkgs.neovim ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/nvim \
        --prefix PATH : ${lib.makeBinPath neovim-deps}
    '';
  };
in
{
  home.packages = [
    pkgs.vscode
    pkgs.emacs-pgtk
    neovim-wrapped
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";
  xdg.configFile."emacs".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/emacs";
}
