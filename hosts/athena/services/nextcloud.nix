let
  domain = "nextcloud.philippschuetz.com";
  port = 8001;
in { pkgs, inputs, config, ... }: {
  sops.secrets."nextcloud/admin_pass" = { };
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      hostName = domain;
      https = true;
      home = "/mnt/ssd-pool/nextcloud";
      database.createLocally = true;
      config = {
        dbtype = "pgsql";
        overwriteprotocol = "https";
        adminuser = "admin";
        adminpassFile = config.sops.secrets."nextcloud/admin_pass".path;
      };
    };

    nginx.virtualHosts = {
      "${domain}" = {
        enableACME = true;
        forceSSL = true;
        listen = [ { addr = "127.0.0.1"; port = port; } ];
      };
    };
  };
}