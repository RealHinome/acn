{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;
    
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;

    casks = [
      "thunderbird"
      "orbstack"
      "postman"
      "visual-studio-code"
      "tor-browser"
      "protonvpn"
    ];
  };
}
