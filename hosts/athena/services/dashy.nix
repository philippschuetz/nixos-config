let
  domain = "dashy.philippschuetz.com";
  domain_tailscale = "t.dashy.philippschuetz.com";
  port = 8004;
in { pkgs, config, ... }: {
  config = {
    virtualisation.oci-containers.containers = {
      "dashy" = {
        image = "ghcr.io/lissy93/dashy:3.1.0";
        ports = ["127.0.0.1:${toString port}:8080"];
        volumes = [
          "/mnt/ssd-volume/dashy/config.yml:/app/user-data/conf.yml"
        ];
        environment = {
          NODE_ENV = "production";
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