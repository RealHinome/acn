{ config, pkgs, ... }:

{
  imports = [
    ./languages/nodejs.nix
    ./languages/rust.nix
    ./languages/elixir.nix
    ./languages/latex.nix
    ./programs/git.nix
    ./programs/vim.nix
    ./programs/terminal.nix
  ];

  home.stateVersion = "24.05";
}
