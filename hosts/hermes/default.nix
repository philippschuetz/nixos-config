{
    imports = [
      ./hardware-configuration.nix
      ./services
      ../common/global
    ];

    networking = {
      hostName = "hermes";
      useDHCP = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
      };
    };

    users.users.philipp = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
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

    environment.systemPackages = with pkgs; [
      vim
      wget
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];  

    system.stateVersion = "24.05";
}