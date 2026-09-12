{
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./languages/rust.nix
    ./languages/verus.nix
    ./languages/python.nix
    ./languages/nodejs.nix
    ./languages/latex.nix

    ./programs/git.nix
    ./programs/gpg.nix
    ./programs/shell.nix
    ./programs/iterm2.nix
    ./programs/neovim.nix
    ./programs/virtualization.nix
  ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    # Do not bump this merely because Home Manager is upgraded.
    stateVersion = "24.11";

    packages = with pkgs; [
      shellcheck
      shfmt
      tree
      wget
      yq-go
    ];

    sessionVariables = {
      PAGER = "less";
      MANPAGER = "nvim +Man!";
    };
  };

  programs = {
    bat.enable = true;
    fd.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    less = {
      enable = true;
      options = ["-F" "-R" "-X"];
    };
    ripgrep.enable = true;
    stylua.enable = true;
  };

  home.activation.defaultApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [[ -d /Applications/Thunderbird.app ]]; then
      if [[ "$(${pkgs.duti}/bin/duti -d mailto 2>/dev/null || true)" != "org.mozilla.thunderbird" ]]; then
        run ${pkgs.duti}/bin/duti -s org.mozilla.thunderbird mailto all
      fi

      if [[ "$(${pkgs.duti}/bin/duti -d com.mozilla.thunderbird.mozeml 2>/dev/null || true)" != "org.mozilla.thunderbird" ]]; then
        run ${pkgs.duti}/bin/duti -s org.mozilla.thunderbird com.mozilla.thunderbird.mozeml viewer
      fi
    else
      echo "Skipping default mail application: Thunderbird is not installed yet" >&2
    fi
  '';
}
