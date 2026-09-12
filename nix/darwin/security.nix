{...}: {
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
