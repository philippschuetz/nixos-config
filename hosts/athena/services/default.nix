{
  imports = [
    ../../common/optional/nginx.nix
    ../../common/optional/acme.nix
    ../../common/optional/docker.nix
    ./audiobookshelf.nix
    ./jellyfin.nix
    ./minecraft-server.nix
    ./syncthing.nix
    ./vaultwarden.nix
  ];
}