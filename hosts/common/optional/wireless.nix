{ config, ... }: {
  sops.secrets."wireless.env" = { };

  networking.wireless = {
    enable = true;
    fallbackToWPA2 = false;
    # Declarative
    environmentFile = config.sops.secrets."wireless.env".path;
    networks = {
      "@home_ssid@" = {
        psk = "@home_psk@";
      };
    };

    # Imperative
    allowAuxiliaryImperativeNetworks = true;
    userControlled = {
      enable = true;
      group = "network";
    };
    extraConfig = ''
      update_config=1
    '';
  };

  # Ensure group exists
  users.groups.network = {};

  systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
