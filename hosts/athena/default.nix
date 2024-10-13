{ pkgs, config, ... }:

{
    imports = [
      ./hardware-configuration.nix
      ./services
      ../common/global
      ../common/optional/ssh.nix
    ];

    sops.secrets."wireless.env" = { };

    networking = {
      hostName = "athena";
      hostId = "463fbe48"; # required by zfs
      useDHCP = true;
      firewall = {
        enable = true;
      };
      wireless = {
        enable = true;
        environmentFile = config.sops.secrets."wireless.env".path;
        networks."@home_ssid@".psk = "@home_psk@";
      };
    };

    users.users."philipp" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        vim
        wget
        tree
        git
        sops
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9IfjgOwAuY4dh4pOXJBJly4YBjC+LK/4AkpYOnbt0q philipp"
      ];
    };

    programs.nix-ld.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];  

    system.stateVersion = "24.05";
}