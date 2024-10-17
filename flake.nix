{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (self) outputs;
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  
  in
  {
    nixosConfigurations = {
      # Webserver
      "hermes" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };

        modules = [
          ./hosts/hermes/default.nix
        ];
      };
      # Homeserver
      "athena" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };

        modules = [
          ./hosts/athena/default.nix
        ];
      };
      # Desktop
      "atlas" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };

        modules = [
          ./hosts/atlas/default.nix
        ];
      };
    };
  };
}
