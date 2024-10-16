{ pkgs, config, lib, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -A";
      l = "ls -CF";
      ll = "ls -alF";
      ls = "ls --color=auto";
      mv = "mv -i";
      rm = "rm -i";
      cp = "cp -i";
      grep = "grep --color=auto";
      ".." = "cd ..";

      vim = "nvim";
      vi = "vim";
      v = "vim";

      ns = "nix shell";
      nsn = "nix shell nixpkgs#";
      nr = "nix run";
      nrn = "nix run nixpkgs#";
      nb = "nix build";
      nbn = "nix build nixpkgs#";
      nf = "nix flake";
      
      nrs = "sudo nixos-rebuild switch --flake";
      nrb = "sudo nixos-rebuild boot --flake";
      nrt = "sudo nixos-rebuild test --flake";
    };
    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/zsh/history";
    };
  };
}
