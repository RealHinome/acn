{pkgs, ...}: let
  # Verus requires rustup and an exact Rust toolchain that can differ from the
  # nixpkgs Rust version. Keep rustup itself declarative, but make mutable
  # toolchain installation an explicit one-time command.
  rustSetup = pkgs.writeShellApplication {
    name = "rust-setup";
    runtimeInputs = [pkgs.rustup];
    text = ''
      set -euo pipefail

      echo "Installing/updating the regular Rust toolchain..."
      rustup toolchain install stable \
        --profile minimal \
        --component rustfmt \
        --component clippy \
        --component rust-analyzer \
        --component rust-src
      rustup default stable

      echo "Installing the Rust toolchain required by the pinned Verus release..."
      rustup toolchain install 1.98.0 \
        --profile minimal \
        --component rustfmt \
        --component rustc-dev \
        --component llvm-tools

      echo
      rustup show
    '';
  };
in {
  home.packages = [
    pkgs.rustup
    rustSetup
  ];
}
