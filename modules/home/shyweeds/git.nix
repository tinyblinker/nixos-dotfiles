{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
  ];
  programs.git = {
    enable = true;
    settings = {
      user.name = "tinyblinker";
      user.email = "2149934895@qq.com";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };
  programs.lazygit = {
    enable = true;
    settings.git.autoFetch = false;
  };
}
