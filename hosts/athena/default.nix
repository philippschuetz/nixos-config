{ pkgs, ... }:

{
    imports = [
      ./hardware-configuration.nix
      ./services
      ../common/global
    ];

    networking = {
      hostName = "athena";
      useDHCP = true;
      firewall = {
        enable = true;
      };
      wireless = {
        enable = true;
        environmentFile = "/home/philipp/nixos-config/secrets/wireless.env";
        networks."@SSID_HOME@".psk = "@PSK_HOME@";
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

    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
      openFirewall = true;
    };

    programs.nix-ld.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];  

    system.stateVersion = "24.05";
}