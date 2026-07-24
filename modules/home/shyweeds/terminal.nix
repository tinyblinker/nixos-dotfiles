{ config, ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        padding = {
          top = 1;
          left = 2;
          right = 4;
        };
        color = {
          "1" = "38;2;92;131;116";
          "2" = "38;2;147;177;166";
        };
      };
      display = {
        separator = "  ";
        color.keys = "38;2;147;177;166";
      };
      modules = [
        "break"
        {
          type = "title";
          color = {
            user = "38;2;92;131;116";
            host = "38;2;147;177;166";
          };
        }
        {
          type = "separator";
          string = "─";
          length = 26;
        }
        {
          type = "os";
          key = "  OS";
          keyColor = "green";
        }
        {
          type = "kernel";
          key = "  Kernel";
          keyColor = "green";
        }
        {
          type = "uptime";
          key = "  Uptime";
          keyColor = "green";
        }
        {
          type = "packages";
          key = "  Pkgs";
          keyColor = "green";
        }
        {
          type = "shell";
          key = "  Shell";
          keyColor = "green";
        }
        {
          type = "wm";
          key = "  WM";
          keyColor = "green";
        }
        {
          type = "terminal";
          key = "  Term";
          keyColor = "green";
        }
        "break"
        {
          type = "cpu";
          key = "  CPU";
          keyColor = "cyan";
        }
        {
          type = "gpu";
          key = "  GPU";
          keyColor = "cyan";
        }
        {
          type = "memory";
          key = "  RAM";
          keyColor = "cyan";
        }
        {
          type = "disk";
          key = "  Disk";
          keyColor = "cyan";
        }
        "break"
        {
          type = "colors";
          symbol = "circle";
          paddingLeft = 2;
        }
        "break"
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
