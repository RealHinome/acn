{...}: {
  networking.applicationFirewall = {
    enable = true;
    blockAllIncoming = true;
    enableStealthMode = true;

    # Do not implicitly punch firewall holes merely because an app is signed.
    allowSigned = false;
    allowSignedApp = false;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

    loginwindow = {
      GuestEnabled = false;
      SHOWFULLNAME = true;
    };
  };
}
