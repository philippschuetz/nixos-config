{ pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services
    ../common/global
    ../common/users/philipp
    ../common/optional/ssh.nix
    ../common/optional/wireless.nix
  ];

  networking = {
    hostName = "athena";
    hostId = "463fbe48"; # required by zfs
    useDHCP = true;
    firewall = {
      enable = true;
    };
  };

  system.stateVersion = "24.05";
}