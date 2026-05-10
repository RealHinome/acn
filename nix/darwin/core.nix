{ config, pkgs, ... }:

{
  users.users.acn = {
    name = "acn";
    home = "/Users/acn";
  };

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;

  system.stateVersion = 4;
}
