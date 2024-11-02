{ pkgs, lib, inputs, ... }:

{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "minecraft-server"
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    
    dataDir = "/mnt/ssd-volume/minecraft-data";
    # runDir = "/mnt/ssd-volume/minecraft-run"; deprecated, replaced by tmux socket path
    managementSystem.tmux = {
      enable = true;
      socketPath = name: "/mnt/ssd-volume/minecraft-run/${name}.sock";
    };

    openFirewall = true;

    user = "philipp";
    group = "users";

    servers = {
      fabric-server = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_1;

        serverProperties = {};
        whitelist = {};

        symlinks = {
          "mods" = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
            Lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/9x0igjLz/lithium-fabric-mc1.21.1-0.13.1.jar";
              sha512 = "4250a630d43492da35c4c197ae43082186938fdcb42bafcb6ccad925b79f583abdfdc17ce792c6c6686883f7f109219baecb4906a65d524026d4e288bfbaf146";
            };
          });
        };
      };
    };
  };
}