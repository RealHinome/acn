{...}: {
  # iTerm2 automatically watches this DynamicProfiles directory.
  home.file."Library/Application Support/iTerm2/DynamicProfiles/nix-managed.json".source =
    ../config/iterm2-profile.json;
}
