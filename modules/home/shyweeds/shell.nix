{
  programs.opencode.enable = true;
  programs.bash.enable = true;
  programs.fish = {
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
}
