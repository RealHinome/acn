{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.ghq];

  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    settings = {
      user = {
        name = "acn";
        email = "acn@gravitalia.com";
        useConfigOnly = true;
      };

      am.threeWay = true;
      core = {
        fsmonitor = true;
        untrackedCache = true;
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      fetch = {
        prune = true;
        writeCommitGraph = true;
        fsckObjects = true;
      };
      format.signOff = true;
      ghq.root = "${config.home.homeDirectory}/Desktop/Dev";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      diff.algorithm = "histogram";
      merge.conflictStyle = "zdiff3";
      protocol.version = 2;
      rerere.enabled = true;
      commit.verbose = true;
      transfer.fsckObjects = true;
    };

    signing = {
      key = "B9D95C807CB0CF31";
      signByDefault = true;
    };
  };

  programs.gh = {
    enable = true;

    # Keep authentication opt-in; enabling the module should not rewrite the
    # user's existing Git credential setup.
    gitCredentialHelper.enable = false;
  };
}
