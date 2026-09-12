{pkgs, ...}: {
  # Python interpreters and environments are delegated to uv.
  home.packages = with pkgs; [
    uv
    ruff
    basedpyright
  ];

  # Never fall back to Apple's/system Python. Missing interpreters are installed
  # and managed by uv instead.
  home.sessionVariables.UV_MANAGED_PYTHON = "1";
}
