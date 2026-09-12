{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;

    extraPackages = with pkgs; [
      alejandra
      basedpyright
      clang
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
