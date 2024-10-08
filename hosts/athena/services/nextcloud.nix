let
  domain = "nextcloud.philippschuetz.com";
  port = 8001;
in { pkgs, inputs, config, ... }: {
  environment.etc."nextcloud-admin-pass".text = "PWD";
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      hostName = domain;
      https = true;
      home = "/mnt/ssd-pool";
      database.createLocally = true;
      config = {
        dbtype = "pgsql";
        overwriteprotocol = "https";
        adminuser = "admin";
        adminpassFile = "/etc/nextcloud-admin-pass";
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