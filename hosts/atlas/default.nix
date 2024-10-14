{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/philipp
    ../common/optional/wireless.nix
  ];

  networking = {
    hostName = "atlas";
    useDHCP = true;
    firewall = {
      enable = true;
    };
  };

  system.stateVersion = "24.05";
}
