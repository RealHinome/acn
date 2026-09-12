{
  config,
  hostname,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      ll = "eza -la --icons --group-directories-first";
      la = "eza -a --icons";
      lt = "eza --tree --level=2 --icons";
      cat = "bat";
      v = "nvim";
      nixfmt = "nix fmt";
      rebuild = "nh darwin switch --hostname ${hostname}";
      update = "nh darwin switch --hostname ${hostname} --update";
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nh = {
    enable = true;
    darwinFlake = "${config.home.homeDirectory}/mac-config";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      command_timeout = 1000;
      format = "$directory$git_branch$git_status$nix_shell$rust$python$nodejs$line_break$character";
      directory.truncation_length = 4;
      git_branch.symbol = "git:";
      nix_shell.symbol = "nix:";
      rust.symbol = "rs:";
      python.symbol = "py:";
      nodejs.symbol = "node:";
    };
  };
}
