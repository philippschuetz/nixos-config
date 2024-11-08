let
  domain = "jellyfin.philippschuetz.com";
  domain_tailscale = "t.jellyfin.philippschuetz.com";
  port = 8000;
in { pkgs, config, ... }: {
  config = {
    virtualisation.oci-containers.containers = {
      "jellyfin" = {
        image = "jellyfin/jellyfin:10.9.11";
        ports = ["127.0.0.1:${toString port}:8096"];
        volumes = [
          "/mnt/ssd-volume/jellyfin/config:/config"
          "/mnt/ssd-volume/jellyfin/cache:/cache"
          "/mnt/ssd-volume/data/movies:/media1:ro"
          "/mnt/ssd-volume/data/shows:/media2:ro"
        ];
        autoStart = true;
      };
    };
    services.nginx.virtualHosts = {
      "${domain}" = {
        serverName = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
        useACMEHost = domain;
        forceSSL = true;
      };
      "${domain_tailscale}" = {
        serverName = domain_tailscale;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
        };
        useACMEHost = domain_tailscale;
        forceSSL = true;
      };
    };
    sops.secrets."netcup_dns.env" = { };
    security.acme.certs = {
      "${domain}" = {
        domain = "${domain}";
        group = config.services.nginx.group;
        dnsProvider = "netcup";
        environmentFile = config.sops.secrets."netcup_dns.env".path;
      };
      "${domain_tailscale}" = {
        domain = "${domain_tailscale}";
        group = config.services.nginx.group;
        dnsProvider = "netcup";
        environmentFile = config.sops.secrets."netcup_dns.env".path;
      };
    };
  };
}