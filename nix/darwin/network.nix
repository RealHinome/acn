{...}: {
  networking = {
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];

    knownNetworkServices = ["Wi-Fi"];

    applicationFirewall = {
      enable = true;
      blockAllIncoming = true;
      enableStealthMode = true;

      # Do not implicitly punch firewall holes merely because an app is signed.
      allowSigned = false;
      allowSignedApp = false;
    };
  };
}
