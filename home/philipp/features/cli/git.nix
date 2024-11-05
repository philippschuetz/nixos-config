{ pkgs, config, lib, ... }: {
  programs.git = {
    enable = true;
    userName = "philippschuetz";
    userEmail = "mail@philippschuetz.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
