{pkgs, ...}: {
  home.packages = with pkgs; [
    ruff
    basedpyright
  ];

  # Never fall back to Apple's/system Python. Missing interpreters are installed
  # and managed by uv instead.
  programs.uv = {
    enable = true;
    settings.python-preference = "only-managed";
  };
}
