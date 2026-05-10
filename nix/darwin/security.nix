{ config, pkgs, ... }:

{
  networking.applicationFirewall = {
    enable = true;
    blockAllIncoming = true;
    allowSigned = true;
    allowSignedApp = true;
    enableStealthMode = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
