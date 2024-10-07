{lib, ...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
    extraUpFlags = ["--login-server https://tailscale.philippschuetz.com"];
  };
  networking.firewall.allowedUDPPorts = [41641];
}
