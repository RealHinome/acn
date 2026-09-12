{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };

    # GUI applications only.
    casks = [
      "iterm2"
      "skim"
      "thunderbird"
      "orbstack"
      "postman"
      "tor-browser"
      "protonvpn"
    ];
  };
}
