{pkgs, ...}: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "acn";
        email = "acn@gravitalia.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      fetch.prune = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
      diff.algorithm = "histogram";
      merge.conflictStyle = "zdiff3";
      rerere.enabled = true;
      commit.verbose = true;
    };

    signing = {
      key = "383E89059FFC5EDA";
      signByDefault = true;
    };
  };

  home.packages = [pkgs.gh];
}
