# nixCats 分类定义与打包定义
# 使用方式:被 flake.nix 通过 utils.mkHomeModules 引入
# categoryDefinitions: 定义"有哪些分类,每个分类包含哪些插件/依赖"
# packageDefinitions:  定义"这个 neovim 包启用哪些分类,以及传给 lua 的信息"
{ inputs }:
let
  inherit (inputs.nixCats) utils;
  luaPath = ./nvim;

  # 传给 nixpkgs 的 config,例如 allowUnfree
  extra_pkg_config = { };

  # 抓取所有名为 plugins-<name> 的 input 作为 pkgs.neovimPlugins
  dependencyOverlays = [ (utils.standardPluginOverlay inputs) ];

  # ---------------------------------------------------------------
  # categoryDefinitions:分类 -> 插件/依赖 的映射
  # ---------------------------------------------------------------
  categoryDefinitions =
    {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    }@packageDef:
    {

      # 运行时依赖(LSP、格式化器、linter 等),会加入 neovim 内置终端的 PATH
      lspsAndRuntimeDeps = with pkgs; {
        general = [
          ripgrep
          fd
          tree-sitter
        ];
        nix = [
          nixd
          nixfmt
          deadnix
        ];
        lua = [
          lua-language-server
          stylua
        ];
        c = [
          clang-tools
          gcc
          gdb
        ];
        python = [
          pyright
          black
          ruff
        ];
        rust = [
          rust-analyzer
          rustfmt
          clippy
        ];
        bash = [
          shellcheck
          shellharden
        ];
      };

      # 启动时即加载的插件(不使用 packadd)
      startupPlugins = with pkgs.vimPlugins; {
        general = {
          # lze/lzextras 是懒加载框架本身,必须开机加载
          always = [
            lze
            lzextras
            plenary-nvim
          ];
          # 主题需要开机加载以便设置 colorscheme
          theme = [
            tokyonight-nvim
          ];
        };
      };

      # 懒加载插件(通过 lze 的 packadd 触发)
      optionalPlugins = with pkgs.vimPlugins; {
        general = {
          telescope = [
            telescope-nvim
            telescope-fzf-native-nvim
          ];
          treesitter = [
            nvim-treesitter.withAllGrammars
          ];
          completion = [
            blink-cmp
            luasnip
            friendly-snippets
          ];
          always = [
            nvim-lspconfig
            fidget-nvim
            lualine-nvim
            nvim-web-devicons
            gitsigns-nvim
          ];
          extra = [
            neo-tree-nvim
            nui-nvim
            which-key-nvim
            flash-nvim
            nvim-autopairs
            indent-blankline-nvim
            todo-comments-nvim
          ];
        };
        format = [ pkgs.vimPlugins.conform-nvim ];
        lint = [ pkgs.vimPlugins.nvim-lint ];
      };

      # 共享库,加入 LD_LIBRARY_PATH
      sharedLibraries = {
        general = with pkgs; [ ];
      };

      environmentVariables = { };
      extraWrapperArgs = { };
      python3.libraries = { };
      extraLuaPackages = { };
    };

  # ---------------------------------------------------------------
  # packageDefinitions:启用分类 + 传给 lua 的信息
  # ---------------------------------------------------------------
  packageDefinitions = {
    nvim = { pkgs, name, ... }: {
      settings = {
        suffix-path = true;
        suffix-LD = true;
        wrapRc = true;
        aliases = [
          "vim"
          "vi"
        ];
        hosts.python3.enable = true;
        hosts.node.enable = true;
      };
      categories = {
        general = true;
        format = true;
        lint = true;

        # 语言开关(供 lua 通过 nixCats('lua') 等判断)
        nix = true;
        lua = true;
        c = true;
        python = true;
        rust = true;
        bash = true;

        have_nerd_font = true;
      };
      extra = {
        # nixd 需要 nixpkgs 表达式以及 nixos/home-manager options 路径
        # 使用 inputs.self 保证无论配置在哪都能解析(集成 flake 最佳实践)
        nixdExtras = {
          nixpkgs = "import ${pkgs.path} {}";
          nixos_options = ''(builtins.getFlake "${builtins.toString inputs.self.outPath}").nixosConfigurations.nixos.options'';
          home_manager_options = ''(builtins.getFlake "${builtins.toString inputs.self.outPath}").nixosConfigurations.nixos.options.home-manager.users.type.getSubOptions []'';
        };
      };
    };
  };

  defaultPackageName = "nvim";
in
{
  # 导出 home-manager 模块,供 flake.nix 引入
  homeModule = utils.mkHomeModules {
    moduleNamespace = [ defaultPackageName ];
    inherit
      defaultPackageName
      dependencyOverlays
      luaPath
      categoryDefinitions
      packageDefinitions
      extra_pkg_config
      ;
    nixpkgs = inputs.nixpkgs;
  };
}
