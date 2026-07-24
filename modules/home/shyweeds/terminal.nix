{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        color = {
          "1" = "38;2;92;131;116";
          "2" = "38;2;147;177;166";
        };
      };
      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "disk"
        "colors"
      ];
    };
  };
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = "18";
      cursor_trail = "3";
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = "2";
      background_opacity = 0.8;
    };
    keybindings = {
      "ctrl+shift+enter" = "no_op";
      "ctrl+shift+w" = "no_op";
      "ctrl+shift+q" = "no_op";
    };
  };
}
