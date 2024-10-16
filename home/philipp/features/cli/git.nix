{ pkgs, config, lib, ... }: {
  programs.git = {
    enable = true;
    userName = "philipp-schuetz";
    userEmail = "mail@philippschuetz.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
