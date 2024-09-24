let
  domain = "test.philippschuetz.com";
  port = "8000";
in {

  config = {
    virtualisation.oci-containers.containers = {
      "homepage" = {
        image = "ghcr.io/philipp-schuetz/homepage:main";
        ports = ["127.0.0.1:${port}:80"];
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
