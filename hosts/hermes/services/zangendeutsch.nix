let
  domain = "zangendeutsch.de";
  port = "8001";
in {

  config = {
    virtualisation.oci-containers.containers = {
      "zangendeutsch" = {
        image = "ghcr.io/philipp-schuetz/zangendeutsch.de:main";
        ports = ["127.0.0.1:${port}:3000"];
      };
    };

    services.nginx.virtualHosts = {
      "${domain}" = {
        serverName = domain;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${port}";
        };
        
        enableACME = true;
        forceSSL = true;
      };
    };
  };
}
