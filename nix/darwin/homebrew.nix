{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      # Casks are not content-addressed like Nix packages. Keep rebuilds
      # reproducible and make upgrades a separate, deliberate action.
      autoUpdate = false;
      cleanup = "zap";
      upgrade = false;
    };

    global.autoUpdate = false;

    # GUI applications only.
    casks = [
      "iterm2"
      "skim"
      "thunderbird"
      "orbstack"
      "postman"
      "tor-browser"
      "protonvpn"
      "codex"
      "chatgpt"
      "google-chrome"
      "visual-studio-code"
      "zotero"
    ];
  };
}
