{
  pkgs,
  lib,
  ...
}: let
  verusVersion = "0.2026.09.06.8dea4a2";
  verusfmtVersion = "0.7.3";

  # Official weekly Verus binary release for Apple Silicon macOS. Keep the
  # complete upstream directory together so `verus`, `cargo-verus` and their
  # bundled support files retain the layout expected by the release.
  verus = pkgs.stdenvNoCC.mkDerivation {
    pname = "verus";
    version = verusVersion;

    src = pkgs.fetchurl {
      url = "https://github.com/verus-lang/verus/releases/download/release%2F${verusVersion}/verus-${verusVersion}-arm64-macos.zip";
      hash = "sha256-I74ugRO1C8kXKTd9isAy9ljMUYfjiaMZ2EWPnDewe0o=";
    };

    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.unzip
    ];
    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      mkdir source
      cd source
      unzip -q "$src"
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      verus_binary="$(find . -maxdepth 3 -type f -name verus | head -n 1)"
      if [ -z "$verus_binary" ]; then
        echo "Verus binary not found in release archive" >&2
        find . -maxdepth 3 -print >&2
        exit 1
      fi

      root="$(dirname "$verus_binary")"
      if [ ! -x "$root/verus" ] || [ ! -x "$root/cargo-verus" ]; then
        echo "Unexpected Verus release archive layout" >&2
        find . -maxdepth 3 -print >&2
        exit 1
      fi

      mkdir -p "$out/libexec/verus" "$out/bin"
      cp -R "$root"/. "$out/libexec/verus/"

      makeWrapper "$out/libexec/verus/verus" "$out/bin/verus"
      makeWrapper "$out/libexec/verus/cargo-verus" "$out/bin/cargo-verus"
      runHook postInstall
    '';

    meta = {
      description = "Verified Rust for low-level systems code";
      homepage = "https://github.com/verus-lang/verus";
      license = lib.licenses.mit;
      platforms = ["aarch64-darwin"];
      mainProgram = "verus";
    };
  };

  verusfmt = pkgs.stdenvNoCC.mkDerivation {
    pname = "verusfmt";
    version = verusfmtVersion;

    src = pkgs.fetchurl {
      url = "https://github.com/verus-lang/verusfmt/releases/download/v${verusfmtVersion}/verusfmt-aarch64-apple-darwin.tar.xz";
      hash = "sha256-ofTsq92Yk04s+oxJKyQk53xH1kcUmyvChGNwM9e6Ibk=";
    };

    nativeBuildInputs = [pkgs.xz];
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      binary="$(find . -type f -name verusfmt | head -n 1)"
      if [ -z "$binary" ]; then
        echo "verusfmt binary not found in release archive" >&2
        exit 1
      fi
      install -Dm755 "$binary" "$out/bin/verusfmt"
      runHook postInstall
    '';

    meta = {
      description = "Opinionated formatter for Verus";
      homepage = "https://github.com/verus-lang/verusfmt";
      license = lib.licenses.mit;
      platforms = ["aarch64-darwin"];
      mainProgram = "verusfmt";
    };
  };
in {
  home.packages = [verus verusfmt];
}
