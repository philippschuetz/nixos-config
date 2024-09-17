{pkgs, ...}: let
  website = pkgs.inputs.website.default;
in {
  services.nginx.virtualHosts = {
    "philippschuetz.com" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "/" = {
          root = "${website}/public";
          extraConfig = ''
            add_header Cache-Control "max-age=${toString (minutes 5)}, stale-while-revalidate=${toString (minutes 15)}";
          '';
        };
      };
    };
  };
}
