{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      
      config = {
        allowUnfree = true;
      };
    };
  
  in
  {
    nixosConfigurations = {
      hermes = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };

        modules = [
          ./hosts/hermes/default.nix
        ];
      };
    };
  };
}
