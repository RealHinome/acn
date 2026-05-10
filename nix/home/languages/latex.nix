{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tectonic
  ];
}
