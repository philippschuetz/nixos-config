{
  imports = [
    ../../common/optional/nginx.nix
    ../../common/optional/acme.nix
    ../../common/optional/docker.nix

    ./homepage.nix
    ./minecraft-proxy.nix
    ./zangendeutsch.nix
  ];
}
