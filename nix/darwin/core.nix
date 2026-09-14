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
    # cache.nixos.org and its signing key are included by nix-darwin.
    substituters = ["https://coliasgroup.cachix.org"];

    trusted-public-keys = [
      "coliasgroup.cachix.org-1:vYRVaHS5FCjsGmVVXlzF5LaIWjeEK17W+MHxK886zIE="
    ];

    # Flakes must not be able to silently add substituters or trust keys.
    accept-flake-config = false;
    experimental-features = ["nix-command" "flakes"];
    flake-registry = "";
    require-sigs = true;
    sandbox = true;
    trusted-users = ["root"];
    warn-dirty = false;
  };

  # This configuration is flake-only; avoid mutable channel state.
  nix.channel.enable = false;
  nix.optimise.automatic = true;

  # Keep the formatter available even outside Home Manager shells.
  environment.systemPackages = with pkgs; [
    alejandra
    bazel
  ];

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

      "com.apple.Safari" = {
        IncludeDevelopMenu = true;
        WebKitDeveloperExtrasEnabledPreferenceKey = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      };

      "com.google.Chrome" = {
        ExtensionInstallForcelist = [
          "ddkjiahejlhfcafbddmgiahcphecmpfh;https://clients2.google.com/service/update2/crx"
        ];
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
