{ pkgs, ... }:
{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    # TODO: add vimrc.
  };
}
