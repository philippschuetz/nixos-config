{
  networking.nat = {
    enable = true;
    externalRedirects = [
      {
        protocol = "tcp";
        sourcePort = 25565;
        destination = "100.104.253.34"; # tailnet ip of athena
        destinationPort = 25565;
      }
    ];
  };
}
