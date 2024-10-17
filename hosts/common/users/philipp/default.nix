{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager # TODO
  ];

  sops.secrets."philipp-password" = {
    neededForUsers = true;
  };

  users.mutableUsers = false;
  users.users."philipp" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ifTheyExist [
      "audio"
      "network"
      "video"
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9IfjgOwAuY4dh4pOXJBJly4YBjC+LK/4AkpYOnbt0q philipp"
    ];
    hashedPasswordFile = config.sops.secrets."philipp-password".path;
    packages = [pkgs.home-manager];
  };

  home-manager.users."philipp" = import ../../../../home/philipp/${config.networking.hostName}.nix;

  # security.pam.services = {
  #   swaylock = {};
  # };
}
