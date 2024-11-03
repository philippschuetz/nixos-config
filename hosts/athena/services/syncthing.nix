let
  domain = "syncthing.philippschuetz.com";
  domain_tailscale = "t.syncthing.philippschuetz.com";
  port = 8384;
in { pkgs, config, ... }: {
  config = {
    services.syncthing = {
      enable = true;
      configDir = "/mnt/ssd-volume/syncthing";
      dataDir = "/mnt/ssd-volume/data";
      guiAddress = "0.0.0.0:${toString port}";
      extraFlags = [];
      user = "philipp";
      group = "users";
      relay.enable = false;
      systemService = true;
      openDefaultPorts = true;
      overrideFolders = true;
      overrideDevices = true;
      settings = {
        folders = {
          "notes" = {
            devices = [ "android" "mbp" "tumbleweed" ];
            type = "sendreceive";
            copyOwnershipFromParent = false;
            path = "/mnt/ssd-volume/data/notes";
            enable = true;
            versioning = {
              type = "simple";
              params.keep = "10";
            };
          };
          "documents" = {
            devices = [ "android" "mbp" "tumbleweed" ];
            type = "sendreceive";
            copyOwnershipFromParent = false;
            path = "/mnt/ssd-volume/data/documents";
            enable = true;
            versioning = {
              type = "simple";
              params.keep = "10";
            };
          };
        };
        devices = {
          "android" = {
            addresses = [
              "tcp://192.168.2.128" # local ip
              "tcp://100.78.210.69" # tailscale ip
            ];
            id = "I6IQ3D7-U62B5EW-OPVIURK-4P2ANAX-UU3MCME-NVHK7EI-NK4FTIM-2JYJOQG";
            autoAcceptFolders = false;
          };
          "mbp" = {
            addresses = [
              "tcp://192.168.2.132" # local ip
              "tcp://100.123.240.45" # tailscale ip
            ];
            id = "6E23XOI-RJG7QUC-U2UVFJL-UONWKVG-PD236PN-DITLY3F-5H6LU35-E4T37QE";
            autoAcceptFolders = false;
          };
          "tumbleweed" = {
            addresses = [
              "tcp://192.168.2.203" # local ip
              "tcp://100.94.215.90" # tailscale ip
            ];
            id = "3IYC6WG-Q5OCPNB-RWGCGU4-J76FWXW-A5GLRM6-2UB3KPZ-RPRIV54-2JBCOQW";
            autoAcceptFolders = false;
          };
        };
        gui = {
          theme = "black";
        };
        options = {
          urAccepted = -1;
          relaysEnabled = false;
          maxFolderConcurrency = 0;
        };
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