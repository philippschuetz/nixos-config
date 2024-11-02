{
  networking.nat = {
    enable = true;
    forwardPorts = {
      destination = "100.104.253.34:25565"; # tailnet ip of athena
      proto = "tcp";
      sourcePort = 25565;
    };
  };
}
