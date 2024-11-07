let
  minecraftData = "/mnt/ssd-volume/minecraft-data";
  minecraftBackup = "/mnt/ssd-volume/minecraft-backup";
in { pkgs, lib, inputs, ... }:
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
        autoStart = true;
        package = pkgs.fabricServers.fabric-1_21_1;

        serverProperties = {
          difficulty = "hard";
          gamemode = "survival";
          max-players = 20;
          motd = "§fCan you exit §avim§f?";
          allow-flight = false;
          white-list = true;
          spawn-protection = 16;
          simulation-distance = 16;
          view-distance = 32;
        };
        
        jvmOpts = "-Xms4096M -Xmx4096M";

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
  systemd.services.myscript-service = {
    description = "Minecraft server backup script";
    startAt = "*-*-* 00:04:00";
    serviceConfig.ExecStart = ''
      #!/bin/bash
      systemctl stop minecraft-server-fabric-server.service

      # Variables
      SOURCE_FOLDER="${minecraftData}"
      DESTINATION_FOLDER="${minecraftBackup}"
      DATE=$(date +"%d-%m-%Y")
      TAR_FILENAME="$DATE.tar.gz"
      TAR_FILEPATH="$DESTINATION_FOLDER/$TAR_FILENAME"

      mkdir -p "$DESTINATION_FOLDER"

      # Compress the folder
      tar -czf "$TAR_FILEPATH" -C "$(dirname "$SOURCE_FOLDER")" "$(basename "$SOURCE_FOLDER")"

      # Remove old backups if there are more than 7 tar.gz files in the destination folder
      NUM_FILES=$(ls "$DESTINATION_FOLDER"/*.tar.gz 2>/dev/null | wc -l)
      if [ "$NUM_FILES" -gt 7 ]; then
          # Find and delete the oldest files until only 7 remain
          ls -t "$DESTINATION_FOLDER"/*.tar.gz | tail -n +8 | xargs rm -f
      fi

      systemctl start minecraft-server-fabric-server.service
    '';
    wantedBy = [ "multi-user.target" ];
  };
}