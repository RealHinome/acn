{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      alejandra
      basedpyright
      fd
      lua-language-server
      nil
      prettier
      ripgrep
      ruff
      stylua
      tectonic
      texlab
      typescript-language-server
      tree-sitter
    ];
  };

  xdg.configFile."nvim/init.lua".source = ../config/init.lua;
}
