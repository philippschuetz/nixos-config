{lib, ...}: {
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
    ];
  };
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
    time.timeZone = lib.mkDefault "Europe/Berlin";
}
