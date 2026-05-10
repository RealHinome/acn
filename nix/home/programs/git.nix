{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "acn";
    userEmail = "acn@gravitalia.com";
    
    signing = {
      key = "69B9603E8240456C";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.gpg.enable = true;
}
