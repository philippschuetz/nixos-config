{lib, ...}: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "tail504d04.ts.net" ];
}