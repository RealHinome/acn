{
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
      alejandra
      bat
      fd
      jq
      ripgrep
      shellcheck
      shfmt
      stylua
      tree
      wget
      yq-go
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GIT_EDITOR = "nvim";
      PAGER = "less -FRX";
      MANPAGER = "nvim +Man!";
    };
  };

  programs.home-manager.enable = true;
}
