let
  domain = "vaultwarden.philippschuetz.com";
  domain_tailscale = "t.vaultwarden.philippschuetz.com";
  port = 8002;
in { pkgs, config, ... }: {
  config = {
    virtualisation.oci-containers.containers = {
      "vaultwarden" = {
        image = "vaultwarden/server:1.32.1";
        ports = ["127.0.0.1:${toString port}:80"];
        volumes = [
          "/mnt/ssd-volume/vaultwarden/data/:/data/"
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