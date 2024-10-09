{ pkgs, inputs, config, ... }: {
  sops.secrets."netcup_dns.env" = { };
  security.acme = {
    defaults.email = "mail@philippschuetz.com";
    acceptTerms = true;
    certs = {
      "philippschuetz.com" = {
        domain = "*.philippschuetz.com";
        group = config.services.nginx.group;
        dnsProvider = "netcup";
        environmentFile = config.sops.secrets."netcup_dns.env".path;
      };
    };
  };
}
