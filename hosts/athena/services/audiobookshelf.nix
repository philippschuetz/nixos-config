let
  domain = "audiobookshelf.philippschuetz.com";
  domain_tailscale = "t.audiobookshelf.philippschuetz.com";
  port = 8003;
in { pkgs, config, ... }: {
  config = {
    virtualisation.oci-containers.containers = {
      "audiobookshelf" = {
        image = "ghcr.io/advplyr/audiobookshelf:2.16.2";
        ports = ["127.0.0.1:${toString port}:80"];
        volumes = [
          "/mnt/ssd-volume/data/audio/audiobooks:/audiobooks"
          "/mnt/ssd-volume/data/audio/podcasts:/podcasts"
          "/mnt/ssd-volume/audiobookshelf/config:/config"
          "/mnt/ssd-volume/audiobookshelf/metadata:/metadata"
        ];
        environment = {
          TZ = "Europe/Berlin";
        };
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