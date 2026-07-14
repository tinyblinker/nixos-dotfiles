{
  programs = {
    direnv = {
      enable = true;
      enableFishIntegration = true;
      # NOTE: let nix store the evalutions in the dirs
      # without being cleared by the "nix-collect-garbage"
      nix-direnv.enable = true;
    };
    opencode.enable = true;
    bash.enable = true;
    fish = {
      enable = true;
      interactiveShellInit = "fish_vi_key_bindings";
      shellAliases = {
        btw = "echo i use nixos, btw";
      };
      functions = {
        y = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          command yazi $argv --cwd-file="$tmp"
          if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
            builtin cd -- "$cwd"
          end
          command rm -f -- "$tmp"
        '';
      };
    };
  };
}
