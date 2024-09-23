{
  imports = [
    ../../common/optional/nginx.nix
    ../../common/optional/acme.nix
    # ../../common/optional/docker.nix

    ./headscale.nix
    ./homepage.nix
    ./zangendeutsch.nix
  ];
}
