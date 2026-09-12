{
  pkgs,
  username,
  ...
}: {
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  ids.gids.nixbld = 350;

  system.primaryUser = username;
  system.stateVersion = 4;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" username];
    warn-dirty = false;
  };

  nix.optimise.automatic = true;

  # Keep the formatter available even outside Home Manager shells.
  environment.systemPackages = [pkgs.alejandra];

  # Used by iTerm2, Neovim, lualine, etc.
  fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];

  programs.zsh.enable = true;

  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleLanguages = [
          "en-US"
        ];

        AppleLocale = "en_US@rg=FRZZZZ";
      };

      ".GlobalPreferences" = {
        LDMGlobalEnabled = true;
      };

      "com.apple.SubmitDiagInfo" = {
        AutoSubmit = false;
      };
    };

    dock = {
      autohide = false;
      show-recents = true;
      mru-spaces = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };
  };
}
