{ config, pkgs, ... }:

{
  imports = [
    ./core.nix
    ./network.nix
    ./security.nix
    ./homebrew.nix
  ];
}
