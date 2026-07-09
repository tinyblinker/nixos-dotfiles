{
  description = "myNixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    catppuccin.url = "github:catppuccin/nix/v26.05";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";
  };
  # 1. 使用 @inputs 将所有 inputs 捕获到一个变量中
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.shyweeds = import ./home.nix;
              backupFileExtension = "backup";

              # 引入 nixCats 的 home-manager 模块(命名空间为 nvim)
              sharedModules = [ (import ./nvim.nix { inherit inputs; }).homeModule ];

              # 2. 将整个 inputs 对象传递给 home.nix
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
