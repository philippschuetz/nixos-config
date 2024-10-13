{ pkgs, ... }:

{
    imports = [
      ./hardware-configuration.nix
      ./services
      ../common/global
      ../common/optional/ssh.nix
    ];

    networking = {
      hostName = "hermes";
      useDHCP = true;
      firewall = {
        enable = true;
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
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9IfjgOwAuY4dh4pOXJBJly4YBjC+LK/4AkpYOnbt0q philipp"
      ];
    };

    programs.nix-ld.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];  

    system.stateVersion = "24.05";
}