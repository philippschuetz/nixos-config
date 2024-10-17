{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}: {
  imports =
    [ ../features/cli ../features/nvim ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = true;
    };
  };

  # systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;

  home = {
    username = lib.mkDefault "philipp";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.05";
    #sessionPath = ["$HOME/.local/bin"];
    sessionVariables = {
      FLAKE = "$HOME/nixos-config";
    };
  };
}
