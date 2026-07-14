{
  home.username = "shyweeds";
  home.homeDirectory = "/home/shyweeds";
  home.stateVersion = "26.05";
  home.sessionPath = [ "$HOME/.cargo/bin/" ];

  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./editors.nix
    ./terminal.nix
    ./theming.nix
    ./input-method.nix
    ./greetd-session.nix
    ./battery-monitor.nix
    ./desktop/default.nix
  ];
}
