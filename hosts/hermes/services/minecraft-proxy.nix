{
  networking.nat = {
    enable = true;
    externalInterface = "ens3";
    externalIP = "202.61.193.219";
    forwardPorts = [
      {
        destination = "100.104.253.34:25565"; # tailnet ip of athena
        proto = "tcp";
        sourcePort = 25565;
      }
    ];
  };
  networking.firewall.allowedTCPPorts = [ 25565 ];
}
