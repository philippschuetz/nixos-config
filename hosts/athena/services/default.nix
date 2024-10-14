{
  imports = [
    ../../common/optional/nginx.nix
    ../../common/optional/acme.nix
    ../../common/optional/docker.nix
    ./jellyfin.nix
    ./syncthing.nix
    ./vaultwarden.nix
  ];
}